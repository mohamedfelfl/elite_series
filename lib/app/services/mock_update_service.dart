import 'dart:async';
import '../../features/settings/models/app_update_info.dart';
import 'update_service.dart';

/// Mock implementation of [UpdateService] used for automated unit tests
/// and debugging update lifecycle flows without requiring a packaged vpk binary.
class MockUpdateService implements UpdateService {
  String currentVersion;
  AppUpdateInfo? mockAvailableUpdate;
  bool shouldFailCheck;
  bool shouldFailDownload;
  bool wasRestartCalled = false;
  bool wasExitCalled = false;

  MockUpdateService({
    this.currentVersion = '1.0.0',
    this.mockAvailableUpdate,
    this.shouldFailCheck = false,
    this.shouldFailDownload = false,
  });

  @override
  Future<void> initialize({String? updateUrl}) async {
    // No-op for mock
  }

  @override
  Future<String> getCurrentVersion() async {
    return currentVersion;
  }

  @override
  Future<AppUpdateInfo?> checkForUpdate({bool allowDowngrade = false}) async {
    if (shouldFailCheck) {
      throw Exception('Network unreachable or mock check failure');
    }
    return mockAvailableUpdate;
  }

  @override
  Stream<double> downloadUpdate(AppUpdateInfo info) async* {
    if (shouldFailDownload) {
      throw Exception('Mock download failed due to network timeout');
    }

    const steps = 10;
    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      yield i / steps.toDouble();
    }
  }

  @override
  Future<void> applyUpdateAndRestart() async {
    wasRestartCalled = true;
  }

  @override
  Future<void> applyUpdateOnExit() async {
    wasExitCalled = true;
  }
}
