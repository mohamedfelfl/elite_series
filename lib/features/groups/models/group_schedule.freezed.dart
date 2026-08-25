// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupSchedule {

 int? get id; int? get groupId; String get dayOfWeek; String get time;
/// Create a copy of GroupSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupScheduleCopyWith<GroupSchedule> get copyWith => _$GroupScheduleCopyWithImpl<GroupSchedule>(this as GroupSchedule, _$identity);

  /// Serializes this GroupSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,dayOfWeek,time);

@override
String toString() {
  return 'GroupSchedule(id: $id, groupId: $groupId, dayOfWeek: $dayOfWeek, time: $time)';
}


}

/// @nodoc
abstract mixin class $GroupScheduleCopyWith<$Res>  {
  factory $GroupScheduleCopyWith(GroupSchedule value, $Res Function(GroupSchedule) _then) = _$GroupScheduleCopyWithImpl;
@useResult
$Res call({
 int? id, int? groupId, String dayOfWeek, String time
});




}
/// @nodoc
class _$GroupScheduleCopyWithImpl<$Res>
    implements $GroupScheduleCopyWith<$Res> {
  _$GroupScheduleCopyWithImpl(this._self, this._then);

  final GroupSchedule _self;
  final $Res Function(GroupSchedule) _then;

/// Create a copy of GroupSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? groupId = freezed,Object? dayOfWeek = null,Object? time = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupSchedule].
extension GroupSchedulePatterns on GroupSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupSchedule value)  $default,){
final _that = this;
switch (_that) {
case _GroupSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _GroupSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? groupId,  String dayOfWeek,  String time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupSchedule() when $default != null:
return $default(_that.id,_that.groupId,_that.dayOfWeek,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? groupId,  String dayOfWeek,  String time)  $default,) {final _that = this;
switch (_that) {
case _GroupSchedule():
return $default(_that.id,_that.groupId,_that.dayOfWeek,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? groupId,  String dayOfWeek,  String time)?  $default,) {final _that = this;
switch (_that) {
case _GroupSchedule() when $default != null:
return $default(_that.id,_that.groupId,_that.dayOfWeek,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupSchedule implements GroupSchedule {
  const _GroupSchedule({this.id, this.groupId, required this.dayOfWeek, required this.time});
  factory _GroupSchedule.fromJson(Map<String, dynamic> json) => _$GroupScheduleFromJson(json);

@override final  int? id;
@override final  int? groupId;
@override final  String dayOfWeek;
@override final  String time;

/// Create a copy of GroupSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupScheduleCopyWith<_GroupSchedule> get copyWith => __$GroupScheduleCopyWithImpl<_GroupSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,dayOfWeek,time);

@override
String toString() {
  return 'GroupSchedule(id: $id, groupId: $groupId, dayOfWeek: $dayOfWeek, time: $time)';
}


}

/// @nodoc
abstract mixin class _$GroupScheduleCopyWith<$Res> implements $GroupScheduleCopyWith<$Res> {
  factory _$GroupScheduleCopyWith(_GroupSchedule value, $Res Function(_GroupSchedule) _then) = __$GroupScheduleCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? groupId, String dayOfWeek, String time
});




}
/// @nodoc
class __$GroupScheduleCopyWithImpl<$Res>
    implements _$GroupScheduleCopyWith<$Res> {
  __$GroupScheduleCopyWithImpl(this._self, this._then);

  final _GroupSchedule _self;
  final $Res Function(_GroupSchedule) _then;

/// Create a copy of GroupSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? groupId = freezed,Object? dayOfWeek = null,Object? time = null,}) {
  return _then(_GroupSchedule(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
