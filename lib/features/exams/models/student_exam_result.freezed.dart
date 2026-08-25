// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_exam_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentExamResult {

 int get studentId; String get studentName; String get serialNumber; double get totalMarks; double get totalFullMarks; double get percentage; int get examCount;
/// Create a copy of StudentExamResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentExamResultCopyWith<StudentExamResult> get copyWith => _$StudentExamResultCopyWithImpl<StudentExamResult>(this as StudentExamResult, _$identity);

  /// Serializes this StudentExamResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentExamResult&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.totalMarks, totalMarks) || other.totalMarks == totalMarks)&&(identical(other.totalFullMarks, totalFullMarks) || other.totalFullMarks == totalFullMarks)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.examCount, examCount) || other.examCount == examCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,studentName,serialNumber,totalMarks,totalFullMarks,percentage,examCount);

@override
String toString() {
  return 'StudentExamResult(studentId: $studentId, studentName: $studentName, serialNumber: $serialNumber, totalMarks: $totalMarks, totalFullMarks: $totalFullMarks, percentage: $percentage, examCount: $examCount)';
}


}

/// @nodoc
abstract mixin class $StudentExamResultCopyWith<$Res>  {
  factory $StudentExamResultCopyWith(StudentExamResult value, $Res Function(StudentExamResult) _then) = _$StudentExamResultCopyWithImpl;
@useResult
$Res call({
 int studentId, String studentName, String serialNumber, double totalMarks, double totalFullMarks, double percentage, int examCount
});




}
/// @nodoc
class _$StudentExamResultCopyWithImpl<$Res>
    implements $StudentExamResultCopyWith<$Res> {
  _$StudentExamResultCopyWithImpl(this._self, this._then);

  final StudentExamResult _self;
  final $Res Function(StudentExamResult) _then;

/// Create a copy of StudentExamResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? studentName = null,Object? serialNumber = null,Object? totalMarks = null,Object? totalFullMarks = null,Object? percentage = null,Object? examCount = null,}) {
  return _then(_self.copyWith(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,totalMarks: null == totalMarks ? _self.totalMarks : totalMarks // ignore: cast_nullable_to_non_nullable
as double,totalFullMarks: null == totalFullMarks ? _self.totalFullMarks : totalFullMarks // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,examCount: null == examCount ? _self.examCount : examCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentExamResult].
extension StudentExamResultPatterns on StudentExamResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentExamResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentExamResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentExamResult value)  $default,){
final _that = this;
switch (_that) {
case _StudentExamResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentExamResult value)?  $default,){
final _that = this;
switch (_that) {
case _StudentExamResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int studentId,  String studentName,  String serialNumber,  double totalMarks,  double totalFullMarks,  double percentage,  int examCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentExamResult() when $default != null:
return $default(_that.studentId,_that.studentName,_that.serialNumber,_that.totalMarks,_that.totalFullMarks,_that.percentage,_that.examCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int studentId,  String studentName,  String serialNumber,  double totalMarks,  double totalFullMarks,  double percentage,  int examCount)  $default,) {final _that = this;
switch (_that) {
case _StudentExamResult():
return $default(_that.studentId,_that.studentName,_that.serialNumber,_that.totalMarks,_that.totalFullMarks,_that.percentage,_that.examCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int studentId,  String studentName,  String serialNumber,  double totalMarks,  double totalFullMarks,  double percentage,  int examCount)?  $default,) {final _that = this;
switch (_that) {
case _StudentExamResult() when $default != null:
return $default(_that.studentId,_that.studentName,_that.serialNumber,_that.totalMarks,_that.totalFullMarks,_that.percentage,_that.examCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentExamResult implements StudentExamResult {
  const _StudentExamResult({required this.studentId, required this.studentName, required this.serialNumber, required this.totalMarks, required this.totalFullMarks, required this.percentage, this.examCount = 0});
  factory _StudentExamResult.fromJson(Map<String, dynamic> json) => _$StudentExamResultFromJson(json);

@override final  int studentId;
@override final  String studentName;
@override final  String serialNumber;
@override final  double totalMarks;
@override final  double totalFullMarks;
@override final  double percentage;
@override@JsonKey() final  int examCount;

/// Create a copy of StudentExamResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentExamResultCopyWith<_StudentExamResult> get copyWith => __$StudentExamResultCopyWithImpl<_StudentExamResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentExamResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentExamResult&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.totalMarks, totalMarks) || other.totalMarks == totalMarks)&&(identical(other.totalFullMarks, totalFullMarks) || other.totalFullMarks == totalFullMarks)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.examCount, examCount) || other.examCount == examCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,studentName,serialNumber,totalMarks,totalFullMarks,percentage,examCount);

@override
String toString() {
  return 'StudentExamResult(studentId: $studentId, studentName: $studentName, serialNumber: $serialNumber, totalMarks: $totalMarks, totalFullMarks: $totalFullMarks, percentage: $percentage, examCount: $examCount)';
}


}

/// @nodoc
abstract mixin class _$StudentExamResultCopyWith<$Res> implements $StudentExamResultCopyWith<$Res> {
  factory _$StudentExamResultCopyWith(_StudentExamResult value, $Res Function(_StudentExamResult) _then) = __$StudentExamResultCopyWithImpl;
@override @useResult
$Res call({
 int studentId, String studentName, String serialNumber, double totalMarks, double totalFullMarks, double percentage, int examCount
});




}
/// @nodoc
class __$StudentExamResultCopyWithImpl<$Res>
    implements _$StudentExamResultCopyWith<$Res> {
  __$StudentExamResultCopyWithImpl(this._self, this._then);

  final _StudentExamResult _self;
  final $Res Function(_StudentExamResult) _then;

/// Create a copy of StudentExamResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? studentName = null,Object? serialNumber = null,Object? totalMarks = null,Object? totalFullMarks = null,Object? percentage = null,Object? examCount = null,}) {
  return _then(_StudentExamResult(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,totalMarks: null == totalMarks ? _self.totalMarks : totalMarks // ignore: cast_nullable_to_non_nullable
as double,totalFullMarks: null == totalFullMarks ? _self.totalFullMarks : totalFullMarks // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,examCount: null == examCount ? _self.examCount : examCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
