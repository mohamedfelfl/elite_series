// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Student {

 int? get id; String get serialNumber; String get name; String get address; String get phone1; String get phone2; String get fatherJob; String get school; String get previousTeacher; String? get grade;/// Foreign key to the Group table
 int? get groupId;/// Populated as a join field — not stored in student table
 String? get groupName; String get studentStatus; String? get attendanceDay; String get notes; DateTime? get createdAt;
/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentCopyWith<Student> get copyWith => _$StudentCopyWithImpl<Student>(this as Student, _$identity);

  /// Serializes this Student to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Student&&(identical(other.id, id) || other.id == id)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone1, phone1) || other.phone1 == phone1)&&(identical(other.phone2, phone2) || other.phone2 == phone2)&&(identical(other.fatherJob, fatherJob) || other.fatherJob == fatherJob)&&(identical(other.school, school) || other.school == school)&&(identical(other.previousTeacher, previousTeacher) || other.previousTeacher == previousTeacher)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.studentStatus, studentStatus) || other.studentStatus == studentStatus)&&(identical(other.attendanceDay, attendanceDay) || other.attendanceDay == attendanceDay)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serialNumber,name,address,phone1,phone2,fatherJob,school,previousTeacher,grade,groupId,groupName,studentStatus,attendanceDay,notes,createdAt);

@override
String toString() {
  return 'Student(id: $id, serialNumber: $serialNumber, name: $name, address: $address, phone1: $phone1, phone2: $phone2, fatherJob: $fatherJob, school: $school, previousTeacher: $previousTeacher, grade: $grade, groupId: $groupId, groupName: $groupName, studentStatus: $studentStatus, attendanceDay: $attendanceDay, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudentCopyWith<$Res>  {
  factory $StudentCopyWith(Student value, $Res Function(Student) _then) = _$StudentCopyWithImpl;
@useResult
$Res call({
 int? id, String serialNumber, String name, String address, String phone1, String phone2, String fatherJob, String school, String previousTeacher, String? grade, int? groupId, String? groupName, String studentStatus, String? attendanceDay, String notes, DateTime? createdAt
});




}
/// @nodoc
class _$StudentCopyWithImpl<$Res>
    implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._self, this._then);

  final Student _self;
  final $Res Function(Student) _then;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? serialNumber = null,Object? name = null,Object? address = null,Object? phone1 = null,Object? phone2 = null,Object? fatherJob = null,Object? school = null,Object? previousTeacher = null,Object? grade = freezed,Object? groupId = freezed,Object? groupName = freezed,Object? studentStatus = null,Object? attendanceDay = freezed,Object? notes = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone1: null == phone1 ? _self.phone1 : phone1 // ignore: cast_nullable_to_non_nullable
as String,phone2: null == phone2 ? _self.phone2 : phone2 // ignore: cast_nullable_to_non_nullable
as String,fatherJob: null == fatherJob ? _self.fatherJob : fatherJob // ignore: cast_nullable_to_non_nullable
as String,school: null == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as String,previousTeacher: null == previousTeacher ? _self.previousTeacher : previousTeacher // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,studentStatus: null == studentStatus ? _self.studentStatus : studentStatus // ignore: cast_nullable_to_non_nullable
as String,attendanceDay: freezed == attendanceDay ? _self.attendanceDay : attendanceDay // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Student].
extension StudentPatterns on Student {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Student value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Student value)  $default,){
final _that = this;
switch (_that) {
case _Student():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Student value)?  $default,){
final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String serialNumber,  String name,  String address,  String phone1,  String phone2,  String fatherJob,  String school,  String previousTeacher,  String? grade,  int? groupId,  String? groupName,  String studentStatus,  String? attendanceDay,  String notes,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Student() when $default != null:
return $default(_that.id,_that.serialNumber,_that.name,_that.address,_that.phone1,_that.phone2,_that.fatherJob,_that.school,_that.previousTeacher,_that.grade,_that.groupId,_that.groupName,_that.studentStatus,_that.attendanceDay,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String serialNumber,  String name,  String address,  String phone1,  String phone2,  String fatherJob,  String school,  String previousTeacher,  String? grade,  int? groupId,  String? groupName,  String studentStatus,  String? attendanceDay,  String notes,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Student():
return $default(_that.id,_that.serialNumber,_that.name,_that.address,_that.phone1,_that.phone2,_that.fatherJob,_that.school,_that.previousTeacher,_that.grade,_that.groupId,_that.groupName,_that.studentStatus,_that.attendanceDay,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String serialNumber,  String name,  String address,  String phone1,  String phone2,  String fatherJob,  String school,  String previousTeacher,  String? grade,  int? groupId,  String? groupName,  String studentStatus,  String? attendanceDay,  String notes,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Student() when $default != null:
return $default(_that.id,_that.serialNumber,_that.name,_that.address,_that.phone1,_that.phone2,_that.fatherJob,_that.school,_that.previousTeacher,_that.grade,_that.groupId,_that.groupName,_that.studentStatus,_that.attendanceDay,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Student implements Student {
  const _Student({this.id, required this.serialNumber, required this.name, this.address = '', this.phone1 = '', this.phone2 = '', this.fatherJob = '', this.school = '', this.previousTeacher = '', this.grade, this.groupId, this.groupName, this.studentStatus = 'normal', this.attendanceDay, this.notes = '', this.createdAt});
  factory _Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

@override final  int? id;
@override final  String serialNumber;
@override final  String name;
@override@JsonKey() final  String address;
@override@JsonKey() final  String phone1;
@override@JsonKey() final  String phone2;
@override@JsonKey() final  String fatherJob;
@override@JsonKey() final  String school;
@override@JsonKey() final  String previousTeacher;
@override final  String? grade;
/// Foreign key to the Group table
@override final  int? groupId;
/// Populated as a join field — not stored in student table
@override final  String? groupName;
@override@JsonKey() final  String studentStatus;
@override final  String? attendanceDay;
@override@JsonKey() final  String notes;
@override final  DateTime? createdAt;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentCopyWith<_Student> get copyWith => __$StudentCopyWithImpl<_Student>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Student&&(identical(other.id, id) || other.id == id)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone1, phone1) || other.phone1 == phone1)&&(identical(other.phone2, phone2) || other.phone2 == phone2)&&(identical(other.fatherJob, fatherJob) || other.fatherJob == fatherJob)&&(identical(other.school, school) || other.school == school)&&(identical(other.previousTeacher, previousTeacher) || other.previousTeacher == previousTeacher)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.studentStatus, studentStatus) || other.studentStatus == studentStatus)&&(identical(other.attendanceDay, attendanceDay) || other.attendanceDay == attendanceDay)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serialNumber,name,address,phone1,phone2,fatherJob,school,previousTeacher,grade,groupId,groupName,studentStatus,attendanceDay,notes,createdAt);

@override
String toString() {
  return 'Student(id: $id, serialNumber: $serialNumber, name: $name, address: $address, phone1: $phone1, phone2: $phone2, fatherJob: $fatherJob, school: $school, previousTeacher: $previousTeacher, grade: $grade, groupId: $groupId, groupName: $groupName, studentStatus: $studentStatus, attendanceDay: $attendanceDay, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudentCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$StudentCopyWith(_Student value, $Res Function(_Student) _then) = __$StudentCopyWithImpl;
@override @useResult
$Res call({
 int? id, String serialNumber, String name, String address, String phone1, String phone2, String fatherJob, String school, String previousTeacher, String? grade, int? groupId, String? groupName, String studentStatus, String? attendanceDay, String notes, DateTime? createdAt
});




}
/// @nodoc
class __$StudentCopyWithImpl<$Res>
    implements _$StudentCopyWith<$Res> {
  __$StudentCopyWithImpl(this._self, this._then);

  final _Student _self;
  final $Res Function(_Student) _then;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? serialNumber = null,Object? name = null,Object? address = null,Object? phone1 = null,Object? phone2 = null,Object? fatherJob = null,Object? school = null,Object? previousTeacher = null,Object? grade = freezed,Object? groupId = freezed,Object? groupName = freezed,Object? studentStatus = null,Object? attendanceDay = freezed,Object? notes = null,Object? createdAt = freezed,}) {
  return _then(_Student(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone1: null == phone1 ? _self.phone1 : phone1 // ignore: cast_nullable_to_non_nullable
as String,phone2: null == phone2 ? _self.phone2 : phone2 // ignore: cast_nullable_to_non_nullable
as String,fatherJob: null == fatherJob ? _self.fatherJob : fatherJob // ignore: cast_nullable_to_non_nullable
as String,school: null == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as String,previousTeacher: null == previousTeacher ? _self.previousTeacher : previousTeacher // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,studentStatus: null == studentStatus ? _self.studentStatus : studentStatus // ignore: cast_nullable_to_non_nullable
as String,attendanceDay: freezed == attendanceDay ? _self.attendanceDay : attendanceDay // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
