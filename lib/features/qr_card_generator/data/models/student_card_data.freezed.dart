// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_card_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentCardData {

 int get id; String get studentCode; String get fullName; String get stageName; String get groupName; String get groupSchedule; String get qrPayload; DateTime? get createdAt;
/// Create a copy of StudentCardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentCardDataCopyWith<StudentCardData> get copyWith => _$StudentCardDataCopyWithImpl<StudentCardData>(this as StudentCardData, _$identity);

  /// Serializes this StudentCardData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentCardData&&(identical(other.id, id) || other.id == id)&&(identical(other.studentCode, studentCode) || other.studentCode == studentCode)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.stageName, stageName) || other.stageName == stageName)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.groupSchedule, groupSchedule) || other.groupSchedule == groupSchedule)&&(identical(other.qrPayload, qrPayload) || other.qrPayload == qrPayload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentCode,fullName,stageName,groupName,groupSchedule,qrPayload,createdAt);

@override
String toString() {
  return 'StudentCardData(id: $id, studentCode: $studentCode, fullName: $fullName, stageName: $stageName, groupName: $groupName, groupSchedule: $groupSchedule, qrPayload: $qrPayload, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudentCardDataCopyWith<$Res>  {
  factory $StudentCardDataCopyWith(StudentCardData value, $Res Function(StudentCardData) _then) = _$StudentCardDataCopyWithImpl;
@useResult
$Res call({
 int id, String studentCode, String fullName, String stageName, String groupName, String groupSchedule, String qrPayload, DateTime? createdAt
});




}
/// @nodoc
class _$StudentCardDataCopyWithImpl<$Res>
    implements $StudentCardDataCopyWith<$Res> {
  _$StudentCardDataCopyWithImpl(this._self, this._then);

  final StudentCardData _self;
  final $Res Function(StudentCardData) _then;

/// Create a copy of StudentCardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentCode = null,Object? fullName = null,Object? stageName = null,Object? groupName = null,Object? groupSchedule = null,Object? qrPayload = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,studentCode: null == studentCode ? _self.studentCode : studentCode // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,stageName: null == stageName ? _self.stageName : stageName // ignore: cast_nullable_to_non_nullable
as String,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,groupSchedule: null == groupSchedule ? _self.groupSchedule : groupSchedule // ignore: cast_nullable_to_non_nullable
as String,qrPayload: null == qrPayload ? _self.qrPayload : qrPayload // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentCardData].
extension StudentCardDataPatterns on StudentCardData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentCardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentCardData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentCardData value)  $default,){
final _that = this;
switch (_that) {
case _StudentCardData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentCardData value)?  $default,){
final _that = this;
switch (_that) {
case _StudentCardData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String studentCode,  String fullName,  String stageName,  String groupName,  String groupSchedule,  String qrPayload,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentCardData() when $default != null:
return $default(_that.id,_that.studentCode,_that.fullName,_that.stageName,_that.groupName,_that.groupSchedule,_that.qrPayload,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String studentCode,  String fullName,  String stageName,  String groupName,  String groupSchedule,  String qrPayload,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _StudentCardData():
return $default(_that.id,_that.studentCode,_that.fullName,_that.stageName,_that.groupName,_that.groupSchedule,_that.qrPayload,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String studentCode,  String fullName,  String stageName,  String groupName,  String groupSchedule,  String qrPayload,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StudentCardData() when $default != null:
return $default(_that.id,_that.studentCode,_that.fullName,_that.stageName,_that.groupName,_that.groupSchedule,_that.qrPayload,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentCardData implements StudentCardData {
  const _StudentCardData({required this.id, required this.studentCode, required this.fullName, this.stageName = '', this.groupName = '', this.groupSchedule = '', required this.qrPayload, this.createdAt});
  factory _StudentCardData.fromJson(Map<String, dynamic> json) => _$StudentCardDataFromJson(json);

@override final  int id;
@override final  String studentCode;
@override final  String fullName;
@override@JsonKey() final  String stageName;
@override@JsonKey() final  String groupName;
@override@JsonKey() final  String groupSchedule;
@override final  String qrPayload;
@override final  DateTime? createdAt;

/// Create a copy of StudentCardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentCardDataCopyWith<_StudentCardData> get copyWith => __$StudentCardDataCopyWithImpl<_StudentCardData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentCardDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentCardData&&(identical(other.id, id) || other.id == id)&&(identical(other.studentCode, studentCode) || other.studentCode == studentCode)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.stageName, stageName) || other.stageName == stageName)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.groupSchedule, groupSchedule) || other.groupSchedule == groupSchedule)&&(identical(other.qrPayload, qrPayload) || other.qrPayload == qrPayload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentCode,fullName,stageName,groupName,groupSchedule,qrPayload,createdAt);

@override
String toString() {
  return 'StudentCardData(id: $id, studentCode: $studentCode, fullName: $fullName, stageName: $stageName, groupName: $groupName, groupSchedule: $groupSchedule, qrPayload: $qrPayload, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudentCardDataCopyWith<$Res> implements $StudentCardDataCopyWith<$Res> {
  factory _$StudentCardDataCopyWith(_StudentCardData value, $Res Function(_StudentCardData) _then) = __$StudentCardDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String studentCode, String fullName, String stageName, String groupName, String groupSchedule, String qrPayload, DateTime? createdAt
});




}
/// @nodoc
class __$StudentCardDataCopyWithImpl<$Res>
    implements _$StudentCardDataCopyWith<$Res> {
  __$StudentCardDataCopyWithImpl(this._self, this._then);

  final _StudentCardData _self;
  final $Res Function(_StudentCardData) _then;

/// Create a copy of StudentCardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentCode = null,Object? fullName = null,Object? stageName = null,Object? groupName = null,Object? groupSchedule = null,Object? qrPayload = null,Object? createdAt = freezed,}) {
  return _then(_StudentCardData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,studentCode: null == studentCode ? _self.studentCode : studentCode // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,stageName: null == stageName ? _self.stageName : stageName // ignore: cast_nullable_to_non_nullable
as String,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,groupSchedule: null == groupSchedule ? _self.groupSchedule : groupSchedule // ignore: cast_nullable_to_non_nullable
as String,qrPayload: null == qrPayload ? _self.qrPayload : qrPayload // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
