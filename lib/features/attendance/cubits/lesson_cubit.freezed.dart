// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonState {

 List<Lesson> get dailyLessons; Lesson? get activeLesson; List<Map<String, dynamic>> get attendedRoster; List<Map<String, dynamic>> get absentRoster; bool get isLoading; bool get scanSuccess; String? get lastScannedStudent; String? get error; DateTime? get selectedDate;
/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonStateCopyWith<LessonState> get copyWith => _$LessonStateCopyWithImpl<LessonState>(this as LessonState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonState&&const DeepCollectionEquality().equals(other.dailyLessons, dailyLessons)&&(identical(other.activeLesson, activeLesson) || other.activeLesson == activeLesson)&&const DeepCollectionEquality().equals(other.attendedRoster, attendedRoster)&&const DeepCollectionEquality().equals(other.absentRoster, absentRoster)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.scanSuccess, scanSuccess) || other.scanSuccess == scanSuccess)&&(identical(other.lastScannedStudent, lastScannedStudent) || other.lastScannedStudent == lastScannedStudent)&&(identical(other.error, error) || other.error == error)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dailyLessons),activeLesson,const DeepCollectionEquality().hash(attendedRoster),const DeepCollectionEquality().hash(absentRoster),isLoading,scanSuccess,lastScannedStudent,error,selectedDate);

@override
String toString() {
  return 'LessonState(dailyLessons: $dailyLessons, activeLesson: $activeLesson, attendedRoster: $attendedRoster, absentRoster: $absentRoster, isLoading: $isLoading, scanSuccess: $scanSuccess, lastScannedStudent: $lastScannedStudent, error: $error, selectedDate: $selectedDate)';
}


}

/// @nodoc
abstract mixin class $LessonStateCopyWith<$Res>  {
  factory $LessonStateCopyWith(LessonState value, $Res Function(LessonState) _then) = _$LessonStateCopyWithImpl;
@useResult
$Res call({
 List<Lesson> dailyLessons, Lesson? activeLesson, List<Map<String, dynamic>> attendedRoster, List<Map<String, dynamic>> absentRoster, bool isLoading, bool scanSuccess, String? lastScannedStudent, String? error, DateTime? selectedDate
});


$LessonCopyWith<$Res>? get activeLesson;

}
/// @nodoc
class _$LessonStateCopyWithImpl<$Res>
    implements $LessonStateCopyWith<$Res> {
  _$LessonStateCopyWithImpl(this._self, this._then);

  final LessonState _self;
  final $Res Function(LessonState) _then;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyLessons = null,Object? activeLesson = freezed,Object? attendedRoster = null,Object? absentRoster = null,Object? isLoading = null,Object? scanSuccess = null,Object? lastScannedStudent = freezed,Object? error = freezed,Object? selectedDate = freezed,}) {
  return _then(_self.copyWith(
dailyLessons: null == dailyLessons ? _self.dailyLessons : dailyLessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,activeLesson: freezed == activeLesson ? _self.activeLesson : activeLesson // ignore: cast_nullable_to_non_nullable
as Lesson?,attendedRoster: null == attendedRoster ? _self.attendedRoster : attendedRoster // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,absentRoster: null == absentRoster ? _self.absentRoster : absentRoster // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,scanSuccess: null == scanSuccess ? _self.scanSuccess : scanSuccess // ignore: cast_nullable_to_non_nullable
as bool,lastScannedStudent: freezed == lastScannedStudent ? _self.lastScannedStudent : lastScannedStudent // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonCopyWith<$Res>? get activeLesson {
    if (_self.activeLesson == null) {
    return null;
  }

  return $LessonCopyWith<$Res>(_self.activeLesson!, (value) {
    return _then(_self.copyWith(activeLesson: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonState].
extension LessonStatePatterns on LessonState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonState value)  $default,){
final _that = this;
switch (_that) {
case _LessonState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonState value)?  $default,){
final _that = this;
switch (_that) {
case _LessonState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Lesson> dailyLessons,  Lesson? activeLesson,  List<Map<String, dynamic>> attendedRoster,  List<Map<String, dynamic>> absentRoster,  bool isLoading,  bool scanSuccess,  String? lastScannedStudent,  String? error,  DateTime? selectedDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonState() when $default != null:
return $default(_that.dailyLessons,_that.activeLesson,_that.attendedRoster,_that.absentRoster,_that.isLoading,_that.scanSuccess,_that.lastScannedStudent,_that.error,_that.selectedDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Lesson> dailyLessons,  Lesson? activeLesson,  List<Map<String, dynamic>> attendedRoster,  List<Map<String, dynamic>> absentRoster,  bool isLoading,  bool scanSuccess,  String? lastScannedStudent,  String? error,  DateTime? selectedDate)  $default,) {final _that = this;
switch (_that) {
case _LessonState():
return $default(_that.dailyLessons,_that.activeLesson,_that.attendedRoster,_that.absentRoster,_that.isLoading,_that.scanSuccess,_that.lastScannedStudent,_that.error,_that.selectedDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Lesson> dailyLessons,  Lesson? activeLesson,  List<Map<String, dynamic>> attendedRoster,  List<Map<String, dynamic>> absentRoster,  bool isLoading,  bool scanSuccess,  String? lastScannedStudent,  String? error,  DateTime? selectedDate)?  $default,) {final _that = this;
switch (_that) {
case _LessonState() when $default != null:
return $default(_that.dailyLessons,_that.activeLesson,_that.attendedRoster,_that.absentRoster,_that.isLoading,_that.scanSuccess,_that.lastScannedStudent,_that.error,_that.selectedDate);case _:
  return null;

}
}

}

/// @nodoc


class _LessonState implements LessonState {
  const _LessonState({final  List<Lesson> dailyLessons = const [], this.activeLesson, final  List<Map<String, dynamic>> attendedRoster = const [], final  List<Map<String, dynamic>> absentRoster = const [], this.isLoading = false, this.scanSuccess = false, this.lastScannedStudent, this.error, this.selectedDate}): _dailyLessons = dailyLessons,_attendedRoster = attendedRoster,_absentRoster = absentRoster;
  

 final  List<Lesson> _dailyLessons;
@override@JsonKey() List<Lesson> get dailyLessons {
  if (_dailyLessons is EqualUnmodifiableListView) return _dailyLessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyLessons);
}

@override final  Lesson? activeLesson;
 final  List<Map<String, dynamic>> _attendedRoster;
@override@JsonKey() List<Map<String, dynamic>> get attendedRoster {
  if (_attendedRoster is EqualUnmodifiableListView) return _attendedRoster;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attendedRoster);
}

 final  List<Map<String, dynamic>> _absentRoster;
@override@JsonKey() List<Map<String, dynamic>> get absentRoster {
  if (_absentRoster is EqualUnmodifiableListView) return _absentRoster;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_absentRoster);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool scanSuccess;
@override final  String? lastScannedStudent;
@override final  String? error;
@override final  DateTime? selectedDate;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonStateCopyWith<_LessonState> get copyWith => __$LessonStateCopyWithImpl<_LessonState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonState&&const DeepCollectionEquality().equals(other._dailyLessons, _dailyLessons)&&(identical(other.activeLesson, activeLesson) || other.activeLesson == activeLesson)&&const DeepCollectionEquality().equals(other._attendedRoster, _attendedRoster)&&const DeepCollectionEquality().equals(other._absentRoster, _absentRoster)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.scanSuccess, scanSuccess) || other.scanSuccess == scanSuccess)&&(identical(other.lastScannedStudent, lastScannedStudent) || other.lastScannedStudent == lastScannedStudent)&&(identical(other.error, error) || other.error == error)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dailyLessons),activeLesson,const DeepCollectionEquality().hash(_attendedRoster),const DeepCollectionEquality().hash(_absentRoster),isLoading,scanSuccess,lastScannedStudent,error,selectedDate);

@override
String toString() {
  return 'LessonState(dailyLessons: $dailyLessons, activeLesson: $activeLesson, attendedRoster: $attendedRoster, absentRoster: $absentRoster, isLoading: $isLoading, scanSuccess: $scanSuccess, lastScannedStudent: $lastScannedStudent, error: $error, selectedDate: $selectedDate)';
}


}

/// @nodoc
abstract mixin class _$LessonStateCopyWith<$Res> implements $LessonStateCopyWith<$Res> {
  factory _$LessonStateCopyWith(_LessonState value, $Res Function(_LessonState) _then) = __$LessonStateCopyWithImpl;
@override @useResult
$Res call({
 List<Lesson> dailyLessons, Lesson? activeLesson, List<Map<String, dynamic>> attendedRoster, List<Map<String, dynamic>> absentRoster, bool isLoading, bool scanSuccess, String? lastScannedStudent, String? error, DateTime? selectedDate
});


@override $LessonCopyWith<$Res>? get activeLesson;

}
/// @nodoc
class __$LessonStateCopyWithImpl<$Res>
    implements _$LessonStateCopyWith<$Res> {
  __$LessonStateCopyWithImpl(this._self, this._then);

  final _LessonState _self;
  final $Res Function(_LessonState) _then;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyLessons = null,Object? activeLesson = freezed,Object? attendedRoster = null,Object? absentRoster = null,Object? isLoading = null,Object? scanSuccess = null,Object? lastScannedStudent = freezed,Object? error = freezed,Object? selectedDate = freezed,}) {
  return _then(_LessonState(
dailyLessons: null == dailyLessons ? _self._dailyLessons : dailyLessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,activeLesson: freezed == activeLesson ? _self.activeLesson : activeLesson // ignore: cast_nullable_to_non_nullable
as Lesson?,attendedRoster: null == attendedRoster ? _self._attendedRoster : attendedRoster // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,absentRoster: null == absentRoster ? _self._absentRoster : absentRoster // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,scanSuccess: null == scanSuccess ? _self.scanSuccess : scanSuccess // ignore: cast_nullable_to_non_nullable
as bool,lastScannedStudent: freezed == lastScannedStudent ? _self.lastScannedStudent : lastScannedStudent // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonCopyWith<$Res>? get activeLesson {
    if (_self.activeLesson == null) {
    return null;
  }

  return $LessonCopyWith<$Res>(_self.activeLesson!, (value) {
    return _then(_self.copyWith(activeLesson: value));
  });
}
}

// dart format on
