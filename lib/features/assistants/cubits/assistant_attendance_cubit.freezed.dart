// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_attendance_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssistantAttendanceState {

 List<Map<String, dynamic>> get records; bool get isLoading; String? get error;
/// Create a copy of AssistantAttendanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantAttendanceStateCopyWith<AssistantAttendanceState> get copyWith => _$AssistantAttendanceStateCopyWithImpl<AssistantAttendanceState>(this as AssistantAttendanceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantAttendanceState&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(records),isLoading,error);

@override
String toString() {
  return 'AssistantAttendanceState(records: $records, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $AssistantAttendanceStateCopyWith<$Res>  {
  factory $AssistantAttendanceStateCopyWith(AssistantAttendanceState value, $Res Function(AssistantAttendanceState) _then) = _$AssistantAttendanceStateCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> records, bool isLoading, String? error
});




}
/// @nodoc
class _$AssistantAttendanceStateCopyWithImpl<$Res>
    implements $AssistantAttendanceStateCopyWith<$Res> {
  _$AssistantAttendanceStateCopyWithImpl(this._self, this._then);

  final AssistantAttendanceState _self;
  final $Res Function(AssistantAttendanceState) _then;

/// Create a copy of AssistantAttendanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? records = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantAttendanceState].
extension AssistantAttendanceStatePatterns on AssistantAttendanceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantAttendanceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantAttendanceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantAttendanceState value)  $default,){
final _that = this;
switch (_that) {
case _AssistantAttendanceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantAttendanceState value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantAttendanceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> records,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantAttendanceState() when $default != null:
return $default(_that.records,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> records,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AssistantAttendanceState():
return $default(_that.records,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> records,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AssistantAttendanceState() when $default != null:
return $default(_that.records,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AssistantAttendanceState implements AssistantAttendanceState {
  const _AssistantAttendanceState({final  List<Map<String, dynamic>> records = const [], this.isLoading = false, this.error}): _records = records;
  

 final  List<Map<String, dynamic>> _records;
@override@JsonKey() List<Map<String, dynamic>> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of AssistantAttendanceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantAttendanceStateCopyWith<_AssistantAttendanceState> get copyWith => __$AssistantAttendanceStateCopyWithImpl<_AssistantAttendanceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantAttendanceState&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records),isLoading,error);

@override
String toString() {
  return 'AssistantAttendanceState(records: $records, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AssistantAttendanceStateCopyWith<$Res> implements $AssistantAttendanceStateCopyWith<$Res> {
  factory _$AssistantAttendanceStateCopyWith(_AssistantAttendanceState value, $Res Function(_AssistantAttendanceState) _then) = __$AssistantAttendanceStateCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> records, bool isLoading, String? error
});




}
/// @nodoc
class __$AssistantAttendanceStateCopyWithImpl<$Res>
    implements _$AssistantAttendanceStateCopyWith<$Res> {
  __$AssistantAttendanceStateCopyWithImpl(this._self, this._then);

  final _AssistantAttendanceState _self;
  final $Res Function(_AssistantAttendanceState) _then;

/// Create a copy of AssistantAttendanceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? records = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_AssistantAttendanceState(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
