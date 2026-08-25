// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Attendance {

 int? get id; int? get lessonId; int get studentId; DateTime get date; AttendanceStatus get status;/// Optional notes (e.g., which other lesson was attended)
 String get notes; String? get studentName; String? get serialNumber; String? get groupName;
/// Create a copy of Attendance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceCopyWith<Attendance> get copyWith => _$AttendanceCopyWithImpl<Attendance>(this as Attendance, _$identity);

  /// Serializes this Attendance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attendance&&(identical(other.id, id) || other.id == id)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.groupName, groupName) || other.groupName == groupName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lessonId,studentId,date,status,notes,studentName,serialNumber,groupName);

@override
String toString() {
  return 'Attendance(id: $id, lessonId: $lessonId, studentId: $studentId, date: $date, status: $status, notes: $notes, studentName: $studentName, serialNumber: $serialNumber, groupName: $groupName)';
}


}

/// @nodoc
abstract mixin class $AttendanceCopyWith<$Res>  {
  factory $AttendanceCopyWith(Attendance value, $Res Function(Attendance) _then) = _$AttendanceCopyWithImpl;
@useResult
$Res call({
 int? id, int? lessonId, int studentId, DateTime date, AttendanceStatus status, String notes, String? studentName, String? serialNumber, String? groupName
});




}
/// @nodoc
class _$AttendanceCopyWithImpl<$Res>
    implements $AttendanceCopyWith<$Res> {
  _$AttendanceCopyWithImpl(this._self, this._then);

  final Attendance _self;
  final $Res Function(Attendance) _then;

/// Create a copy of Attendance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? lessonId = freezed,Object? studentId = null,Object? date = null,Object? status = null,Object? notes = null,Object? studentName = freezed,Object? serialNumber = freezed,Object? groupName = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,lessonId: freezed == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as int?,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,studentName: freezed == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Attendance].
extension AttendancePatterns on Attendance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attendance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attendance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attendance value)  $default,){
final _that = this;
switch (_that) {
case _Attendance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attendance value)?  $default,){
final _that = this;
switch (_that) {
case _Attendance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? lessonId,  int studentId,  DateTime date,  AttendanceStatus status,  String notes,  String? studentName,  String? serialNumber,  String? groupName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attendance() when $default != null:
return $default(_that.id,_that.lessonId,_that.studentId,_that.date,_that.status,_that.notes,_that.studentName,_that.serialNumber,_that.groupName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? lessonId,  int studentId,  DateTime date,  AttendanceStatus status,  String notes,  String? studentName,  String? serialNumber,  String? groupName)  $default,) {final _that = this;
switch (_that) {
case _Attendance():
return $default(_that.id,_that.lessonId,_that.studentId,_that.date,_that.status,_that.notes,_that.studentName,_that.serialNumber,_that.groupName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? lessonId,  int studentId,  DateTime date,  AttendanceStatus status,  String notes,  String? studentName,  String? serialNumber,  String? groupName)?  $default,) {final _that = this;
switch (_that) {
case _Attendance() when $default != null:
return $default(_that.id,_that.lessonId,_that.studentId,_that.date,_that.status,_that.notes,_that.studentName,_that.serialNumber,_that.groupName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attendance implements Attendance {
  const _Attendance({this.id, this.lessonId, required this.studentId, required this.date, required this.status, this.notes = '', this.studentName, this.serialNumber, this.groupName});
  factory _Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);

@override final  int? id;
@override final  int? lessonId;
@override final  int studentId;
@override final  DateTime date;
@override final  AttendanceStatus status;
/// Optional notes (e.g., which other lesson was attended)
@override@JsonKey() final  String notes;
@override final  String? studentName;
@override final  String? serialNumber;
@override final  String? groupName;

/// Create a copy of Attendance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceCopyWith<_Attendance> get copyWith => __$AttendanceCopyWithImpl<_Attendance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attendance&&(identical(other.id, id) || other.id == id)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.groupName, groupName) || other.groupName == groupName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lessonId,studentId,date,status,notes,studentName,serialNumber,groupName);

@override
String toString() {
  return 'Attendance(id: $id, lessonId: $lessonId, studentId: $studentId, date: $date, status: $status, notes: $notes, studentName: $studentName, serialNumber: $serialNumber, groupName: $groupName)';
}


}

/// @nodoc
abstract mixin class _$AttendanceCopyWith<$Res> implements $AttendanceCopyWith<$Res> {
  factory _$AttendanceCopyWith(_Attendance value, $Res Function(_Attendance) _then) = __$AttendanceCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? lessonId, int studentId, DateTime date, AttendanceStatus status, String notes, String? studentName, String? serialNumber, String? groupName
});




}
/// @nodoc
class __$AttendanceCopyWithImpl<$Res>
    implements _$AttendanceCopyWith<$Res> {
  __$AttendanceCopyWithImpl(this._self, this._then);

  final _Attendance _self;
  final $Res Function(_Attendance) _then;

/// Create a copy of Attendance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? lessonId = freezed,Object? studentId = null,Object? date = null,Object? status = null,Object? notes = null,Object? studentName = freezed,Object? serialNumber = freezed,Object? groupName = freezed,}) {
  return _then(_Attendance(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,lessonId: freezed == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as int?,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,studentName: freezed == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
