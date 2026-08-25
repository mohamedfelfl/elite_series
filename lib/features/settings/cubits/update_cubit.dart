import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/services/update_service.dart';
import '../models/app_update_info.dart';
import 'update_state.dart';

/// Cubit managing software update checks, downloading, and applying updates.
class UpdateCubit extends Cubit<UpdateState> {
  final UpdateService _updateService;
  StreamSubscription<double>? _downloadSubscription;
  AppUpdateInfo? _currentUpdateInfo;
  String _cachedCurrentVersion = '1.0.0';

  String get currentVersion => _cachedCurrentVersion;

  UpdateCubit({required UpdateService updateService})
      : _updateService = updateService,
        super(const UpdateInitial());

  /// Initializes version and triggers startup check if requested.
  Future<void> initialize({bool autoCheck = true}) async {
    _cachedCurrentVersion = await _updateService.getCurrentVersion();
    emit(UpdateInitial(currentVersion: _cachedCurrentVersion));
    if (autoCheck) {
      // Small delay on startup so UI renders cleanly before background network check
      Future.delayed(const Duration(milliseconds: 1200), () {
        checkForUpdates(isManual: false);
      });
    }
  }

  /// Checks for available updates from remote repository.
  Future<void> checkForUpdates({bool isManual = false}) async {
    emit(UpdateChecking(isManual: isManual));
    try {
      _cachedCurrentVersion = await _updateService.getCurrentVersion();
      final updateInfo = await _updateService.checkForUpdate();

      if (updateInfo != null) {
        _currentUpdateInfo = updateInfo;
        emit(UpdateAvailable(info: updateInfo, isManual: isManual));
      } else {
        emit(UpdateUpToDate(currentVersion: _cachedCurrentVersion, isManual: isManual));
      }
    } catch (e) {
      emit(UpdateError(message: e.toString(), isManual: isManual));
    }
  }

  /// Initiates download of the discovered update package.
  Future<void> downloadUpdate() async {
    final info = _currentUpdateInfo;
    if (info == null) return;

    emit(UpdateDownloading(info: info, progress: 0.0));
    await _downloadSubscription?.cancel();

    try {
      _downloadSubscription = _updateService.downloadUpdate(info).listen(
        (progress) {
          emit(UpdateDownloading(info: info, progress: progress));
          if (progress >= 1.0) {
            emit(UpdateReadyToInstall(info: info));
          }
        },
        onError: (error) {
          emit(UpdateError(message: error.toString(), isManual: true));
        },
        cancelOnError: true,
      );
    } catch (e) {
      emit(UpdateError(message: e.toString(), isManual: true));
    }
  }

  /// Restarts the application and applies the downloaded update.
  Future<void> restartAndApply() async {
    final info = _currentUpdateInfo;
    if (info != null) {
      emit(UpdateRestarting(info: info));
    }
    await _updateService.applyUpdateAndRestart();
  }

  /// Applies the update on the next application launch / exit.
  Future<void> applyOnExit() async {
    await _updateService.applyUpdateOnExit();
    final current = await _updateService.getCurrentVersion();
    emit(UpdateUpToDate(currentVersion: current));
  }

  /// Dismisses update banner/dialog for the current session.
  void dismissUpdate() async {
    final current = await _updateService.getCurrentVersion();
    emit(UpdateUpToDate(currentVersion: current));
  }

  @override
  Future<void> close() {
    _downloadSubscription?.cancel();
    return super.close();
  }
}
