import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/app/services/mock_update_service.dart';
import 'package:student_management_system/features/settings/cubits/update_cubit.dart';
import 'package:student_management_system/features/settings/cubits/update_state.dart';
import 'package:student_management_system/features/settings/models/app_update_info.dart';

void main() {
  group('UpdateCubit Tests', () {
    late MockUpdateService mockService;
    late UpdateCubit cubit;

    setUp(() {
      mockService = MockUpdateService(currentVersion: '1.0.0');
      cubit = UpdateCubit(updateService: mockService);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('Initial state is UpdateInitial', () {
      expect(cubit.state, isA<UpdateInitial>());
    });

    test('checkForUpdates emits [UpdateChecking, UpdateUpToDate] when no update exists', () async {
      final states = <UpdateState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.checkForUpdates(isManual: false);
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<UpdateChecking>());
      expect((states[0] as UpdateChecking).isManual, isFalse);
      expect(states[1], isA<UpdateUpToDate>());
      expect((states[1] as UpdateUpToDate).currentVersion, '1.0.0');
      await sub.cancel();
    });

    test('checkForUpdates emits [UpdateChecking, UpdateAvailable] when newer version exists', () async {
      mockService.mockAvailableUpdate = const AppUpdateInfo(
        currentVersion: '1.0.0',
        targetVersion: '1.1.0',
        releaseNotes: 'Bug fixes and performance improvements',
      );

      final states = <UpdateState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.checkForUpdates(isManual: true);
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<UpdateChecking>());
      expect((states[0] as UpdateChecking).isManual, isTrue);
      expect(states[1], isA<UpdateAvailable>());
      final available = states[1] as UpdateAvailable;
      expect(available.info.targetVersion, '1.1.0');
      expect(available.isManual, isTrue);
      await sub.cancel();
    });

    test('checkForUpdates emits [UpdateChecking, UpdateError] when network fails', () async {
      mockService.shouldFailCheck = true;

      final states = <UpdateState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.checkForUpdates(isManual: true);
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<UpdateChecking>());
      expect(states[1], isA<UpdateError>());
      expect((states[1] as UpdateError).isManual, isTrue);
      await sub.cancel();
    });

    test('downloadUpdate streams progress and reaches UpdateReadyToInstall', () async {
      mockService.mockAvailableUpdate = const AppUpdateInfo(
        currentVersion: '1.0.0',
        targetVersion: '1.2.0',
      );

      await cubit.checkForUpdates();
      final states = <UpdateState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.downloadUpdate();
      // Wait for progress stream to complete
      await Future.delayed(const Duration(milliseconds: 700));
      await pumpEventQueue();

      expect(states.any((s) => s is UpdateDownloading), isTrue);
      expect(states.last, isA<UpdateReadyToInstall>());
      await sub.cancel();
    });

    test('restartAndApply emits UpdateRestarting and calls service restart', () async {
      mockService.mockAvailableUpdate = const AppUpdateInfo(
        currentVersion: '1.0.0',
        targetVersion: '1.2.0',
      );

      await cubit.checkForUpdates();
      expect(mockService.wasRestartCalled, isFalse);

      await cubit.restartAndApply();
      await pumpEventQueue();

      expect(cubit.state, isA<UpdateRestarting>());
      expect(mockService.wasRestartCalled, isTrue);
    });

    test('applyOnExit triggers service exit-update hook', () async {
      expect(mockService.wasExitCalled, isFalse);
      await cubit.applyOnExit();
      await pumpEventQueue();

      expect(mockService.wasExitCalled, isTrue);
    });

    test('dismissUpdate resets state to UpdateUpToDate', () async {
      mockService.mockAvailableUpdate = const AppUpdateInfo(
        currentVersion: '1.0.0',
        targetVersion: '1.2.0',
      );

      await cubit.checkForUpdates();
      expect(cubit.state, isA<UpdateAvailable>());

      cubit.dismissUpdate();
      await pumpEventQueue();

      expect(cubit.state, isA<UpdateUpToDate>());
    });
  });
}
