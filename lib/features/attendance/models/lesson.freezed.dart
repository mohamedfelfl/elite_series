// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lesson {

 int? get id; int get groupId; String get date;// 'YYYY-MM-DD'
 String get startTime; String? get endTime; String get title; LessonStatus get status; String? get groupName; int get enrolledCount; int get attendedCount; int get otherGroupCount; int get absentCount; DateTime? get createdAt;
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCopyWith<Lesson> get copyWith => _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.enrolledCount, enrolledCount) || other.enrolledCount == enrolledCount)&&(identical(other.attendedCount, attendedCount) || other.attendedCount == attendedCount)&&(identical(other.otherGroupCount, otherGroupCount) || other.otherGroupCount == otherGroupCount)&&(identical(other.absentCount, absentCount) || other.absentCount == absentCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,date,startTime,endTime,title,status,groupName,enrolledCount,attendedCount,otherGroupCount,absentCount,createdAt);

@override
String toString() {
  return 'Lesson(id: $id, groupId: $groupId, date: $date, startTime: $startTime, endTime: $endTime, title: $title, status: $status, groupName: $groupName, enrolledCount: $enrolledCount, attendedCount: $attendedCount, otherGroupCount: $otherGroupCount, absentCount: $absentCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LessonCopyWith<$Res>  {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) = _$LessonCopyWithImpl;
@useResult
$Res call({
 int? id, int groupId, String date, String startTime, String? endTime, String title, LessonStatus status, String? groupName, int enrolledCount, int attendedCount, int otherGroupCount, int absentCount, DateTime? createdAt
});




}
/// @nodoc
class _$LessonCopyWithImpl<$Res>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._self, this._then);

  final Lesson _self;
  final $Res Function(Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? groupId = null,Object? date = null,Object? startTime = null,Object? endTime = freezed,Object? title = null,Object? status = null,Object? groupName = freezed,Object? enrolledCount = null,Object? attendedCount = null,Object? otherGroupCount = null,Object? absentCount = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LessonStatus,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,enrolledCount: null == enrolledCount ? _self.enrolledCount : enrolledCount // ignore: cast_nullable_to_non_nullable
as int,attendedCount: null == attendedCount ? _self.attendedCount : attendedCount // ignore: cast_nullable_to_non_nullable
as int,otherGroupCount: null == otherGroupCount ? _self.otherGroupCount : otherGroupCount // ignore: cast_nullable_to_non_nullable
as int,absentCount: null == absentCount ? _self.absentCount : absentCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Lesson].
extension LessonPatterns on Lesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lesson value)  $default,){
final _that = this;
switch (_that) {
case _Lesson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lesson value)?  $default,){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int groupId,  String date,  String startTime,  String? endTime,  String title,  LessonStatus status,  String? groupName,  int enrolledCount,  int attendedCount,  int otherGroupCount,  int absentCount,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.groupId,_that.date,_that.startTime,_that.endTime,_that.title,_that.status,_that.groupName,_that.enrolledCount,_that.attendedCount,_that.otherGroupCount,_that.absentCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int groupId,  String date,  String startTime,  String? endTime,  String title,  LessonStatus status,  String? groupName,  int enrolledCount,  int attendedCount,  int otherGroupCount,  int absentCount,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Lesson():
return $default(_that.id,_that.groupId,_that.date,_that.startTime,_that.endTime,_that.title,_that.status,_that.groupName,_that.enrolledCount,_that.attendedCount,_that.otherGroupCount,_that.absentCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int groupId,  String date,  String startTime,  String? endTime,  String title,  LessonStatus status,  String? groupName,  int enrolledCount,  int attendedCount,  int otherGroupCount,  int absentCount,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.groupId,_that.date,_that.startTime,_that.endTime,_that.title,_that.status,_that.groupName,_that.enrolledCount,_that.attendedCount,_that.otherGroupCount,_that.absentCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lesson implements Lesson {
  const _Lesson({this.id, required this.groupId, required this.date, required this.startTime, this.endTime, this.title = '', this.status = LessonStatus.scheduled, this.groupName, this.enrolledCount = 0, this.attendedCount = 0, this.otherGroupCount = 0, this.absentCount = 0, this.createdAt});
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

@override final  int? id;
@override final  int groupId;
@override final  String date;
// 'YYYY-MM-DD'
@override final  String startTime;
@override final  String? endTime;
@override@JsonKey() final  String title;
@override@JsonKey() final  LessonStatus status;
@override final  String? groupName;
@override@JsonKey() final  int enrolledCount;
@override@JsonKey() final  int attendedCount;
@override@JsonKey() final  int otherGroupCount;
@override@JsonKey() final  int absentCount;
@override final  DateTime? createdAt;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCopyWith<_Lesson> get copyWith => __$LessonCopyWithImpl<_Lesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.enrolledCount, enrolledCount) || other.enrolledCount == enrolledCount)&&(identical(other.attendedCount, attendedCount) || other.attendedCount == attendedCount)&&(identical(other.otherGroupCount, otherGroupCount) || other.otherGroupCount == otherGroupCount)&&(identical(other.absentCount, absentCount) || other.absentCount == absentCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,date,startTime,endTime,title,status,groupName,enrolledCount,attendedCount,otherGroupCount,absentCount,createdAt);

@override
String toString() {
  return 'Lesson(id: $id, groupId: $groupId, date: $date, startTime: $startTime, endTime: $endTime, title: $title, status: $status, groupName: $groupName, enrolledCount: $enrolledCount, attendedCount: $attendedCount, otherGroupCount: $otherGroupCount, absentCount: $absentCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) = __$LessonCopyWithImpl;
@override @useResult
$Res call({
 int? id, int groupId, String date, String startTime, String? endTime, String title, LessonStatus status, String? groupName, int enrolledCount, int attendedCount, int otherGroupCount, int absentCount, DateTime? createdAt
});




}
/// @nodoc
class __$LessonCopyWithImpl<$Res>
    implements _$LessonCopyWith<$Res> {
  __$LessonCopyWithImpl(this._self, this._then);

  final _Lesson _self;
  final $Res Function(_Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? groupId = null,Object? date = null,Object? startTime = null,Object? endTime = freezed,Object? title = null,Object? status = null,Object? groupName = freezed,Object? enrolledCount = null,Object? attendedCount = null,Object? otherGroupCount = null,Object? absentCount = null,Object? createdAt = freezed,}) {
  return _then(_Lesson(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LessonStatus,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,enrolledCount: null == enrolledCount ? _self.enrolledCount : enrolledCount // ignore: cast_nullable_to_non_nullable
as int,attendedCount: null == attendedCount ? _self.attendedCount : attendedCount // ignore: cast_nullable_to_non_nullable
as int,otherGroupCount: null == otherGroupCount ? _self.otherGroupCount : otherGroupCount // ignore: cast_nullable_to_non_nullable
as int,absentCount: null == absentCount ? _self.absentCount : absentCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
