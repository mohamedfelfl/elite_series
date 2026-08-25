// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceState {

 List<Map<String, dynamic>> get records; bool get isLoading; bool get scanSuccess; String? get lastScannedStudent; String? get error;
/// Create a copy of AttendanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceStateCopyWith<AttendanceState> get copyWith => _$AttendanceStateCopyWithImpl<AttendanceState>(this as AttendanceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceState&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.scanSuccess, scanSuccess) || other.scanSuccess == scanSuccess)&&(identical(other.lastScannedStudent, lastScannedStudent) || other.lastScannedStudent == lastScannedStudent)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(records),isLoading,scanSuccess,lastScannedStudent,error);

@override
String toString() {
  return 'AttendanceState(records: $records, isLoading: $isLoading, scanSuccess: $scanSuccess, lastScannedStudent: $lastScannedStudent, error: $error)';
}


}

/// @nodoc
abstract mixin class $AttendanceStateCopyWith<$Res>  {
  factory $AttendanceStateCopyWith(AttendanceState value, $Res Function(AttendanceState) _then) = _$AttendanceStateCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> records, bool isLoading, bool scanSuccess, String? lastScannedStudent, String? error
});




}
/// @nodoc
class _$AttendanceStateCopyWithImpl<$Res>
    implements $AttendanceStateCopyWith<$Res> {
  _$AttendanceStateCopyWithImpl(this._self, this._then);

  final AttendanceState _self;
  final $Res Function(AttendanceState) _then;

/// Create a copy of AttendanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? records = null,Object? isLoading = null,Object? scanSuccess = null,Object? lastScannedStudent = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,scanSuccess: null == scanSuccess ? _self.scanSuccess : scanSuccess // ignore: cast_nullable_to_non_nullable
as bool,lastScannedStudent: freezed == lastScannedStudent ? _self.lastScannedStudent : lastScannedStudent // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceState].
extension AttendanceStatePatterns on AttendanceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceState value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceState value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> records,  bool isLoading,  bool scanSuccess,  String? lastScannedStudent,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceState() when $default != null:
return $default(_that.records,_that.isLoading,_that.scanSuccess,_that.lastScannedStudent,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> records,  bool isLoading,  bool scanSuccess,  String? lastScannedStudent,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AttendanceState():
return $default(_that.records,_that.isLoading,_that.scanSuccess,_that.lastScannedStudent,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> records,  bool isLoading,  bool scanSuccess,  String? lastScannedStudent,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceState() when $default != null:
return $default(_that.records,_that.isLoading,_that.scanSuccess,_that.lastScannedStudent,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceState implements AttendanceState {
  const _AttendanceState({final  List<Map<String, dynamic>> records = const [], this.isLoading = false, this.scanSuccess = false, this.lastScannedStudent, this.error}): _records = records;
  

 final  List<Map<String, dynamic>> _records;
@override@JsonKey() List<Map<String, dynamic>> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool scanSuccess;
@override final  String? lastScannedStudent;
@override final  String? error;

/// Create a copy of AttendanceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceStateCopyWith<_AttendanceState> get copyWith => __$AttendanceStateCopyWithImpl<_AttendanceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceState&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.scanSuccess, scanSuccess) || other.scanSuccess == scanSuccess)&&(identical(other.lastScannedStudent, lastScannedStudent) || other.lastScannedStudent == lastScannedStudent)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records),isLoading,scanSuccess,lastScannedStudent,error);

@override
String toString() {
  return 'AttendanceState(records: $records, isLoading: $isLoading, scanSuccess: $scanSuccess, lastScannedStudent: $lastScannedStudent, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AttendanceStateCopyWith<$Res> implements $AttendanceStateCopyWith<$Res> {
  factory _$AttendanceStateCopyWith(_AttendanceState value, $Res Function(_AttendanceState) _then) = __$AttendanceStateCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> records, bool isLoading, bool scanSuccess, String? lastScannedStudent, String? error
});




}
/// @nodoc
class __$AttendanceStateCopyWithImpl<$Res>
    implements _$AttendanceStateCopyWith<$Res> {
  __$AttendanceStateCopyWithImpl(this._self, this._then);

  final _AttendanceState _self;
  final $Res Function(_AttendanceState) _then;

/// Create a copy of AttendanceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? records = null,Object? isLoading = null,Object? scanSuccess = null,Object? lastScannedStudent = freezed,Object? error = freezed,}) {
  return _then(_AttendanceState(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,scanSuccess: null == scanSuccess ? _self.scanSuccess : scanSuccess // ignore: cast_nullable_to_non_nullable
as bool,lastScannedStudent: freezed == lastScannedStudent ? _self.lastScannedStudent : lastScannedStudent // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
