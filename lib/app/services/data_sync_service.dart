import 'dart:async';

/// Entities that trigger application-wide data synchronization.
enum SyncEntity {
  students,
  groups,
  payments,
  attendance,
  lessons,
  assistants,
  exams,
  notes,
}

/// Centralized event bus service for coordinating live updates across cubits
/// and tabs without requiring application restart.
class DataSyncService {
  final Duration debounceDuration;
  final StreamController<SyncEntity> _syncController =
      StreamController<SyncEntity>.broadcast();
  final Map<SyncEntity, Timer> _debounceTimers = {};

  DataSyncService({this.debounceDuration = const Duration(milliseconds: 250)});

  /// Global stream of entity change notifications.
  Stream<SyncEntity> get syncStream => _syncController.stream;

  /// Notify that an entity was created, updated, or deleted with debouncing.
  void notify(SyncEntity entity, {bool immediate = false}) {
    if (_syncController.isClosed) return;
    if (immediate || debounceDuration == Duration.zero) {
      _debounceTimers[entity]?.cancel();
      _debounceTimers.remove(entity);
      _syncController.add(entity);
      return;
    }
    _debounceTimers[entity]?.cancel();
    _debounceTimers[entity] = Timer(debounceDuration, () {
      if (!_syncController.isClosed) {
        _syncController.add(entity);
      }
      _debounceTimers.remove(entity);
    });
  }

  void notifyStudentsChanged({bool immediate = false}) =>
      notify(SyncEntity.students, immediate: immediate);
  void notifyGroupsChanged({bool immediate = false}) =>
      notify(SyncEntity.groups, immediate: immediate);
  void notifyPaymentsChanged({bool immediate = false}) =>
      notify(SyncEntity.payments, immediate: immediate);
  void notifyAttendanceChanged({bool immediate = false}) =>
      notify(SyncEntity.attendance, immediate: immediate);
  void notifyLessonsChanged({bool immediate = false}) =>
      notify(SyncEntity.lessons, immediate: immediate);
  void notifyAssistantsChanged({bool immediate = false}) =>
      notify(SyncEntity.assistants, immediate: immediate);
  void notifyExamsChanged({bool immediate = false}) =>
      notify(SyncEntity.exams, immediate: immediate);
  void notifyNotesChanged({bool immediate = false}) =>
      notify(SyncEntity.notes, immediate: immediate);

  void dispose() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    _syncController.close();
  }
}
