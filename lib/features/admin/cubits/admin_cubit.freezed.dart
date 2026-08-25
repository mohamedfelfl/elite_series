// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminState {

 List<User> get users; bool get isLoading; String? get error;
/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminStateCopyWith<AdminState> get copyWith => _$AdminStateCopyWithImpl<AdminState>(this as AdminState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminState&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users),isLoading,error);

@override
String toString() {
  return 'AdminState(users: $users, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $AdminStateCopyWith<$Res>  {
  factory $AdminStateCopyWith(AdminState value, $Res Function(AdminState) _then) = _$AdminStateCopyWithImpl;
@useResult
$Res call({
 List<User> users, bool isLoading, String? error
});




}
/// @nodoc
class _$AdminStateCopyWithImpl<$Res>
    implements $AdminStateCopyWith<$Res> {
  _$AdminStateCopyWithImpl(this._self, this._then);

  final AdminState _self;
  final $Res Function(AdminState) _then;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<User>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminState].
extension AdminStatePatterns on AdminState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminState value)  $default,){
final _that = this;
switch (_that) {
case _AdminState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<User> users,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminState() when $default != null:
return $default(_that.users,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<User> users,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AdminState():
return $default(_that.users,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<User> users,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AdminState() when $default != null:
return $default(_that.users,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AdminState implements AdminState {
  const _AdminState({final  List<User> users = const [], this.isLoading = false, this.error}): _users = users;
  

 final  List<User> _users;
@override@JsonKey() List<User> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStateCopyWith<_AdminState> get copyWith => __$AdminStateCopyWithImpl<_AdminState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminState&&const DeepCollectionEquality().equals(other._users, _users)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),isLoading,error);

@override
String toString() {
  return 'AdminState(users: $users, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AdminStateCopyWith<$Res> implements $AdminStateCopyWith<$Res> {
  factory _$AdminStateCopyWith(_AdminState value, $Res Function(_AdminState) _then) = __$AdminStateCopyWithImpl;
@override @useResult
$Res call({
 List<User> users, bool isLoading, String? error
});




}
/// @nodoc
class __$AdminStateCopyWithImpl<$Res>
    implements _$AdminStateCopyWith<$Res> {
  __$AdminStateCopyWithImpl(this._self, this._then);

  final _AdminState _self;
  final $Res Function(_AdminState) _then;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_AdminState(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<User>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
