import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:student_management_system/app/services/update_service.dart';

void main() {
  group('VelopackUpdateService - isNewerVersion Tests', () {
    test('Correctly identifies newer patch version when current has build number', () {
      // Critical regression test: '1.0.2+3' used to be parsed as '1.0.23' and fail against '1.0.3'
      expect(VelopackUpdateService.isNewerVersion('1.0.2+3', '1.0.3'), isTrue);
      expect(VelopackUpdateService.isNewerVersion('1.0.1+2', '1.0.3'), isTrue);
      expect(VelopackUpdateService.isNewerVersion('2.0.0+12', '2.0.4'), isTrue);
    });

    test('Identifies equal versions as not newer', () {
      expect(VelopackUpdateService.isNewerVersion('1.0.3', '1.0.3'), isFalse);
      expect(VelopackUpdateService.isNewerVersion('1.0.3+4', '1.0.3'), isFalse);
      expect(VelopackUpdateService.isNewerVersion('1.0.3+4', '1.0.3+4'), isFalse);
    });

    test('Identifies newer build number when core version is identical', () {
      expect(VelopackUpdateService.isNewerVersion('1.0.3+4', '1.0.3+5'), isTrue);
      expect(VelopackUpdateService.isNewerVersion('1.0.3', '1.0.3+1'), isTrue);
    });

    test('Identifies newer major and minor versions', () {
      expect(VelopackUpdateService.isNewerVersion('1.0.3+4', '1.1.0'), isTrue);
      expect(VelopackUpdateService.isNewerVersion('1.0.3+4', '2.0.0'), isTrue);
      expect(VelopackUpdateService.isNewerVersion('1.0.3+4', '1.0.4'), isTrue);
    });

    test('Handles v/V prefix in tag names', () {
      expect(VelopackUpdateService.isNewerVersion('1.0.2', 'v1.0.3'), isTrue);
      expect(VelopackUpdateService.isNewerVersion('v1.0.2', 'v1.0.3'), isTrue);
      expect(VelopackUpdateService.isNewerVersion('1.0.3', 'v1.0.3'), isFalse);
    });

    test('Rejects older versions when allowDowngrade is false', () {
      expect(VelopackUpdateService.isNewerVersion('1.0.4', '1.0.3'), isFalse);
      expect(VelopackUpdateService.isNewerVersion('2.0.0', '1.0.3'), isFalse);
    });

    test('Allows any different version when allowDowngrade is true', () {
      expect(VelopackUpdateService.isNewerVersion('1.0.4', '1.0.3', allowDowngrade: true), isTrue);
      expect(VelopackUpdateService.isNewerVersion('1.0.3', '1.0.3', allowDowngrade: true), isFalse);
    });
  });

  group('VelopackUpdateService - checkForUpdate Network & Error Handling', () {
    test('Throws exception on HTTP 403 rate limit instead of silently reporting up-to-date', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Rate limit exceeded', 403);
      });

      final service = VelopackUpdateService(
        owner: 'test_owner',
        repo: 'test_repo',
        httpClient: mockClient,
      );

      expect(
        () => service.checkForUpdate(),
        throwsA(predicate((e) => e.toString().contains('rate limit'))),
      );
    });

    test('Returns null when HTTP 404 (no release found)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not found', 404);
      });

      final service = VelopackUpdateService(
        owner: 'test_owner',
        repo: 'test_repo',
        httpClient: mockClient,
      );

      final result = await service.checkForUpdate();
      expect(result, isNull);
    });

    test('Successfully returns AppUpdateInfo when newer version is found', () async {
      final mockClient = MockClient((request) async {
        final body = json.encode({
          'tag_name': 'v2.0.0',
          'body': 'New features added',
          'published_at': '2026-09-11T12:00:00Z',
          'assets': [
            {
              'name': 'StudentManagementSystem-win-Setup.exe',
              'browser_download_url': 'https://github.com/test/download/Setup.exe',
              'size': 1234567,
            }
          ]
        });
        return http.Response(body, 200, headers: {'content-type': 'application/json'});
      });

      final service = VelopackUpdateService(
        owner: 'test_owner',
        repo: 'test_repo',
        httpClient: mockClient,
      );

      final result = await service.checkForUpdate();
      expect(result, isNotNull);
      expect(result!.targetVersion, '2.0.0');
      expect(result.releaseNotes, 'New features added');
      expect(result.packageSize, 1234567);
    });
  });
}
