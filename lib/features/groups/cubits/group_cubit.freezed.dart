// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupState {

 List<Map<String, dynamic>> get groups; List<Map<String, dynamic>> get groupStudents; List<Map<String, dynamic>> get availableStudents; bool get isLoading; String? get error;
/// Create a copy of GroupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupStateCopyWith<GroupState> get copyWith => _$GroupStateCopyWithImpl<GroupState>(this as GroupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupState&&const DeepCollectionEquality().equals(other.groups, groups)&&const DeepCollectionEquality().equals(other.groupStudents, groupStudents)&&const DeepCollectionEquality().equals(other.availableStudents, availableStudents)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(groups),const DeepCollectionEquality().hash(groupStudents),const DeepCollectionEquality().hash(availableStudents),isLoading,error);

@override
String toString() {
  return 'GroupState(groups: $groups, groupStudents: $groupStudents, availableStudents: $availableStudents, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $GroupStateCopyWith<$Res>  {
  factory $GroupStateCopyWith(GroupState value, $Res Function(GroupState) _then) = _$GroupStateCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> groups, List<Map<String, dynamic>> groupStudents, List<Map<String, dynamic>> availableStudents, bool isLoading, String? error
});




}
/// @nodoc
class _$GroupStateCopyWithImpl<$Res>
    implements $GroupStateCopyWith<$Res> {
  _$GroupStateCopyWithImpl(this._self, this._then);

  final GroupState _self;
  final $Res Function(GroupState) _then;

/// Create a copy of GroupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,Object? groupStudents = null,Object? availableStudents = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,groupStudents: null == groupStudents ? _self.groupStudents : groupStudents // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,availableStudents: null == availableStudents ? _self.availableStudents : availableStudents // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupState].
extension GroupStatePatterns on GroupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupState value)  $default,){
final _that = this;
switch (_that) {
case _GroupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupState value)?  $default,){
final _that = this;
switch (_that) {
case _GroupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> groups,  List<Map<String, dynamic>> groupStudents,  List<Map<String, dynamic>> availableStudents,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupState() when $default != null:
return $default(_that.groups,_that.groupStudents,_that.availableStudents,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> groups,  List<Map<String, dynamic>> groupStudents,  List<Map<String, dynamic>> availableStudents,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _GroupState():
return $default(_that.groups,_that.groupStudents,_that.availableStudents,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> groups,  List<Map<String, dynamic>> groupStudents,  List<Map<String, dynamic>> availableStudents,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _GroupState() when $default != null:
return $default(_that.groups,_that.groupStudents,_that.availableStudents,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _GroupState implements GroupState {
  const _GroupState({final  List<Map<String, dynamic>> groups = const [], final  List<Map<String, dynamic>> groupStudents = const [], final  List<Map<String, dynamic>> availableStudents = const [], this.isLoading = false, this.error}): _groups = groups,_groupStudents = groupStudents,_availableStudents = availableStudents;
  

 final  List<Map<String, dynamic>> _groups;
@override@JsonKey() List<Map<String, dynamic>> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  List<Map<String, dynamic>> _groupStudents;
@override@JsonKey() List<Map<String, dynamic>> get groupStudents {
  if (_groupStudents is EqualUnmodifiableListView) return _groupStudents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupStudents);
}

 final  List<Map<String, dynamic>> _availableStudents;
@override@JsonKey() List<Map<String, dynamic>> get availableStudents {
  if (_availableStudents is EqualUnmodifiableListView) return _availableStudents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableStudents);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of GroupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupStateCopyWith<_GroupState> get copyWith => __$GroupStateCopyWithImpl<_GroupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupState&&const DeepCollectionEquality().equals(other._groups, _groups)&&const DeepCollectionEquality().equals(other._groupStudents, _groupStudents)&&const DeepCollectionEquality().equals(other._availableStudents, _availableStudents)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_groupStudents),const DeepCollectionEquality().hash(_availableStudents),isLoading,error);

@override
String toString() {
  return 'GroupState(groups: $groups, groupStudents: $groupStudents, availableStudents: $availableStudents, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$GroupStateCopyWith<$Res> implements $GroupStateCopyWith<$Res> {
  factory _$GroupStateCopyWith(_GroupState value, $Res Function(_GroupState) _then) = __$GroupStateCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> groups, List<Map<String, dynamic>> groupStudents, List<Map<String, dynamic>> availableStudents, bool isLoading, String? error
});




}
/// @nodoc
class __$GroupStateCopyWithImpl<$Res>
    implements _$GroupStateCopyWith<$Res> {
  __$GroupStateCopyWithImpl(this._self, this._then);

  final _GroupState _self;
  final $Res Function(_GroupState) _then;

/// Create a copy of GroupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? groupStudents = null,Object? availableStudents = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_GroupState(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,groupStudents: null == groupStudents ? _self._groupStudents : groupStudents // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,availableStudents: null == availableStudents ? _self._availableStudents : availableStudents // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
