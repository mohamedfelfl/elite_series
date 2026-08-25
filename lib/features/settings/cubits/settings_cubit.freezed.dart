// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

// General
 String get themeMode; String get language;// Security
// Backup
 bool get autoBackupEnabled; String get autoBackupSchedule; int get maxBackups;// Device Binding
 DeviceBindingStatus get deviceBindingStatus; String get deviceName; String get deviceFingerprint; String get osInfo;// Database Info
 int get databaseSize; Map<String, int> get recordCounts; String get integrityStatus;// Backup Info
 List<BackupInfo> get backups;// UI State
 bool get isLoading; bool get isSaving; String? get successMessage; String? get errorMessage;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.language, language) || other.language == language)&&(identical(other.autoBackupEnabled, autoBackupEnabled) || other.autoBackupEnabled == autoBackupEnabled)&&(identical(other.autoBackupSchedule, autoBackupSchedule) || other.autoBackupSchedule == autoBackupSchedule)&&(identical(other.maxBackups, maxBackups) || other.maxBackups == maxBackups)&&(identical(other.deviceBindingStatus, deviceBindingStatus) || other.deviceBindingStatus == deviceBindingStatus)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.deviceFingerprint, deviceFingerprint) || other.deviceFingerprint == deviceFingerprint)&&(identical(other.osInfo, osInfo) || other.osInfo == osInfo)&&(identical(other.databaseSize, databaseSize) || other.databaseSize == databaseSize)&&const DeepCollectionEquality().equals(other.recordCounts, recordCounts)&&(identical(other.integrityStatus, integrityStatus) || other.integrityStatus == integrityStatus)&&const DeepCollectionEquality().equals(other.backups, backups)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,language,autoBackupEnabled,autoBackupSchedule,maxBackups,deviceBindingStatus,deviceName,deviceFingerprint,osInfo,databaseSize,const DeepCollectionEquality().hash(recordCounts),integrityStatus,const DeepCollectionEquality().hash(backups),isLoading,isSaving,successMessage,errorMessage);

@override
String toString() {
  return 'SettingsState(themeMode: $themeMode, language: $language, autoBackupEnabled: $autoBackupEnabled, autoBackupSchedule: $autoBackupSchedule, maxBackups: $maxBackups, deviceBindingStatus: $deviceBindingStatus, deviceName: $deviceName, deviceFingerprint: $deviceFingerprint, osInfo: $osInfo, databaseSize: $databaseSize, recordCounts: $recordCounts, integrityStatus: $integrityStatus, backups: $backups, isLoading: $isLoading, isSaving: $isSaving, successMessage: $successMessage, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 String themeMode, String language, bool autoBackupEnabled, String autoBackupSchedule, int maxBackups, DeviceBindingStatus deviceBindingStatus, String deviceName, String deviceFingerprint, String osInfo, int databaseSize, Map<String, int> recordCounts, String integrityStatus, List<BackupInfo> backups, bool isLoading, bool isSaving, String? successMessage, String? errorMessage
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? language = null,Object? autoBackupEnabled = null,Object? autoBackupSchedule = null,Object? maxBackups = null,Object? deviceBindingStatus = null,Object? deviceName = null,Object? deviceFingerprint = null,Object? osInfo = null,Object? databaseSize = null,Object? recordCounts = null,Object? integrityStatus = null,Object? backups = null,Object? isLoading = null,Object? isSaving = null,Object? successMessage = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,autoBackupEnabled: null == autoBackupEnabled ? _self.autoBackupEnabled : autoBackupEnabled // ignore: cast_nullable_to_non_nullable
as bool,autoBackupSchedule: null == autoBackupSchedule ? _self.autoBackupSchedule : autoBackupSchedule // ignore: cast_nullable_to_non_nullable
as String,maxBackups: null == maxBackups ? _self.maxBackups : maxBackups // ignore: cast_nullable_to_non_nullable
as int,deviceBindingStatus: null == deviceBindingStatus ? _self.deviceBindingStatus : deviceBindingStatus // ignore: cast_nullable_to_non_nullable
as DeviceBindingStatus,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,deviceFingerprint: null == deviceFingerprint ? _self.deviceFingerprint : deviceFingerprint // ignore: cast_nullable_to_non_nullable
as String,osInfo: null == osInfo ? _self.osInfo : osInfo // ignore: cast_nullable_to_non_nullable
as String,databaseSize: null == databaseSize ? _self.databaseSize : databaseSize // ignore: cast_nullable_to_non_nullable
as int,recordCounts: null == recordCounts ? _self.recordCounts : recordCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,integrityStatus: null == integrityStatus ? _self.integrityStatus : integrityStatus // ignore: cast_nullable_to_non_nullable
as String,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as List<BackupInfo>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String themeMode,  String language,  bool autoBackupEnabled,  String autoBackupSchedule,  int maxBackups,  DeviceBindingStatus deviceBindingStatus,  String deviceName,  String deviceFingerprint,  String osInfo,  int databaseSize,  Map<String, int> recordCounts,  String integrityStatus,  List<BackupInfo> backups,  bool isLoading,  bool isSaving,  String? successMessage,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.themeMode,_that.language,_that.autoBackupEnabled,_that.autoBackupSchedule,_that.maxBackups,_that.deviceBindingStatus,_that.deviceName,_that.deviceFingerprint,_that.osInfo,_that.databaseSize,_that.recordCounts,_that.integrityStatus,_that.backups,_that.isLoading,_that.isSaving,_that.successMessage,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String themeMode,  String language,  bool autoBackupEnabled,  String autoBackupSchedule,  int maxBackups,  DeviceBindingStatus deviceBindingStatus,  String deviceName,  String deviceFingerprint,  String osInfo,  int databaseSize,  Map<String, int> recordCounts,  String integrityStatus,  List<BackupInfo> backups,  bool isLoading,  bool isSaving,  String? successMessage,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.themeMode,_that.language,_that.autoBackupEnabled,_that.autoBackupSchedule,_that.maxBackups,_that.deviceBindingStatus,_that.deviceName,_that.deviceFingerprint,_that.osInfo,_that.databaseSize,_that.recordCounts,_that.integrityStatus,_that.backups,_that.isLoading,_that.isSaving,_that.successMessage,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String themeMode,  String language,  bool autoBackupEnabled,  String autoBackupSchedule,  int maxBackups,  DeviceBindingStatus deviceBindingStatus,  String deviceName,  String deviceFingerprint,  String osInfo,  int databaseSize,  Map<String, int> recordCounts,  String integrityStatus,  List<BackupInfo> backups,  bool isLoading,  bool isSaving,  String? successMessage,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.themeMode,_that.language,_that.autoBackupEnabled,_that.autoBackupSchedule,_that.maxBackups,_that.deviceBindingStatus,_that.deviceName,_that.deviceFingerprint,_that.osInfo,_that.databaseSize,_that.recordCounts,_that.integrityStatus,_that.backups,_that.isLoading,_that.isSaving,_that.successMessage,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.themeMode = 'system', this.language = 'ar', this.autoBackupEnabled = false, this.autoBackupSchedule = 'weekly', this.maxBackups = 5, this.deviceBindingStatus = DeviceBindingStatus.unbound, this.deviceName = '', this.deviceFingerprint = '', this.osInfo = '', this.databaseSize = 0, final  Map<String, int> recordCounts = const {}, this.integrityStatus = '', final  List<BackupInfo> backups = const [], this.isLoading = false, this.isSaving = false, this.successMessage, this.errorMessage}): _recordCounts = recordCounts,_backups = backups;
  

// General
@override@JsonKey() final  String themeMode;
@override@JsonKey() final  String language;
// Security
// Backup
@override@JsonKey() final  bool autoBackupEnabled;
@override@JsonKey() final  String autoBackupSchedule;
@override@JsonKey() final  int maxBackups;
// Device Binding
@override@JsonKey() final  DeviceBindingStatus deviceBindingStatus;
@override@JsonKey() final  String deviceName;
@override@JsonKey() final  String deviceFingerprint;
@override@JsonKey() final  String osInfo;
// Database Info
@override@JsonKey() final  int databaseSize;
 final  Map<String, int> _recordCounts;
@override@JsonKey() Map<String, int> get recordCounts {
  if (_recordCounts is EqualUnmodifiableMapView) return _recordCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_recordCounts);
}

@override@JsonKey() final  String integrityStatus;
// Backup Info
 final  List<BackupInfo> _backups;
// Backup Info
@override@JsonKey() List<BackupInfo> get backups {
  if (_backups is EqualUnmodifiableListView) return _backups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_backups);
}

// UI State
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSaving;
@override final  String? successMessage;
@override final  String? errorMessage;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.language, language) || other.language == language)&&(identical(other.autoBackupEnabled, autoBackupEnabled) || other.autoBackupEnabled == autoBackupEnabled)&&(identical(other.autoBackupSchedule, autoBackupSchedule) || other.autoBackupSchedule == autoBackupSchedule)&&(identical(other.maxBackups, maxBackups) || other.maxBackups == maxBackups)&&(identical(other.deviceBindingStatus, deviceBindingStatus) || other.deviceBindingStatus == deviceBindingStatus)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.deviceFingerprint, deviceFingerprint) || other.deviceFingerprint == deviceFingerprint)&&(identical(other.osInfo, osInfo) || other.osInfo == osInfo)&&(identical(other.databaseSize, databaseSize) || other.databaseSize == databaseSize)&&const DeepCollectionEquality().equals(other._recordCounts, _recordCounts)&&(identical(other.integrityStatus, integrityStatus) || other.integrityStatus == integrityStatus)&&const DeepCollectionEquality().equals(other._backups, _backups)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,language,autoBackupEnabled,autoBackupSchedule,maxBackups,deviceBindingStatus,deviceName,deviceFingerprint,osInfo,databaseSize,const DeepCollectionEquality().hash(_recordCounts),integrityStatus,const DeepCollectionEquality().hash(_backups),isLoading,isSaving,successMessage,errorMessage);

@override
String toString() {
  return 'SettingsState(themeMode: $themeMode, language: $language, autoBackupEnabled: $autoBackupEnabled, autoBackupSchedule: $autoBackupSchedule, maxBackups: $maxBackups, deviceBindingStatus: $deviceBindingStatus, deviceName: $deviceName, deviceFingerprint: $deviceFingerprint, osInfo: $osInfo, databaseSize: $databaseSize, recordCounts: $recordCounts, integrityStatus: $integrityStatus, backups: $backups, isLoading: $isLoading, isSaving: $isSaving, successMessage: $successMessage, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 String themeMode, String language, bool autoBackupEnabled, String autoBackupSchedule, int maxBackups, DeviceBindingStatus deviceBindingStatus, String deviceName, String deviceFingerprint, String osInfo, int databaseSize, Map<String, int> recordCounts, String integrityStatus, List<BackupInfo> backups, bool isLoading, bool isSaving, String? successMessage, String? errorMessage
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? language = null,Object? autoBackupEnabled = null,Object? autoBackupSchedule = null,Object? maxBackups = null,Object? deviceBindingStatus = null,Object? deviceName = null,Object? deviceFingerprint = null,Object? osInfo = null,Object? databaseSize = null,Object? recordCounts = null,Object? integrityStatus = null,Object? backups = null,Object? isLoading = null,Object? isSaving = null,Object? successMessage = freezed,Object? errorMessage = freezed,}) {
  return _then(_SettingsState(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,autoBackupEnabled: null == autoBackupEnabled ? _self.autoBackupEnabled : autoBackupEnabled // ignore: cast_nullable_to_non_nullable
as bool,autoBackupSchedule: null == autoBackupSchedule ? _self.autoBackupSchedule : autoBackupSchedule // ignore: cast_nullable_to_non_nullable
as String,maxBackups: null == maxBackups ? _self.maxBackups : maxBackups // ignore: cast_nullable_to_non_nullable
as int,deviceBindingStatus: null == deviceBindingStatus ? _self.deviceBindingStatus : deviceBindingStatus // ignore: cast_nullable_to_non_nullable
as DeviceBindingStatus,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,deviceFingerprint: null == deviceFingerprint ? _self.deviceFingerprint : deviceFingerprint // ignore: cast_nullable_to_non_nullable
as String,osInfo: null == osInfo ? _self.osInfo : osInfo // ignore: cast_nullable_to_non_nullable
as String,databaseSize: null == databaseSize ? _self.databaseSize : databaseSize // ignore: cast_nullable_to_non_nullable
as int,recordCounts: null == recordCounts ? _self._recordCounts : recordCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,integrityStatus: null == integrityStatus ? _self.integrityStatus : integrityStatus // ignore: cast_nullable_to_non_nullable
as String,backups: null == backups ? _self._backups : backups // ignore: cast_nullable_to_non_nullable
as List<BackupInfo>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
