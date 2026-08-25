// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Mark {

 int? get id; int get examId; int get studentId; double get score;/// Populated via join — not stored in marks table
 String? get studentName;/// Populated via join — not stored in marks table
 String? get examName;/// Populated via join — not stored in marks table
 double? get examFullMark;
/// Create a copy of Mark
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkCopyWith<Mark> get copyWith => _$MarkCopyWithImpl<Mark>(this as Mark, _$identity);

  /// Serializes this Mark to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mark&&(identical(other.id, id) || other.id == id)&&(identical(other.examId, examId) || other.examId == examId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.score, score) || other.score == score)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.examName, examName) || other.examName == examName)&&(identical(other.examFullMark, examFullMark) || other.examFullMark == examFullMark));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,examId,studentId,score,studentName,examName,examFullMark);

@override
String toString() {
  return 'Mark(id: $id, examId: $examId, studentId: $studentId, score: $score, studentName: $studentName, examName: $examName, examFullMark: $examFullMark)';
}


}

/// @nodoc
abstract mixin class $MarkCopyWith<$Res>  {
  factory $MarkCopyWith(Mark value, $Res Function(Mark) _then) = _$MarkCopyWithImpl;
@useResult
$Res call({
 int? id, int examId, int studentId, double score, String? studentName, String? examName, double? examFullMark
});




}
/// @nodoc
class _$MarkCopyWithImpl<$Res>
    implements $MarkCopyWith<$Res> {
  _$MarkCopyWithImpl(this._self, this._then);

  final Mark _self;
  final $Res Function(Mark) _then;

/// Create a copy of Mark
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? examId = null,Object? studentId = null,Object? score = null,Object? studentName = freezed,Object? examName = freezed,Object? examFullMark = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,examId: null == examId ? _self.examId : examId // ignore: cast_nullable_to_non_nullable
as int,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,studentName: freezed == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String?,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,examFullMark: freezed == examFullMark ? _self.examFullMark : examFullMark // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Mark].
extension MarkPatterns on Mark {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mark value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mark() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mark value)  $default,){
final _that = this;
switch (_that) {
case _Mark():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mark value)?  $default,){
final _that = this;
switch (_that) {
case _Mark() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int examId,  int studentId,  double score,  String? studentName,  String? examName,  double? examFullMark)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Mark() when $default != null:
return $default(_that.id,_that.examId,_that.studentId,_that.score,_that.studentName,_that.examName,_that.examFullMark);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int examId,  int studentId,  double score,  String? studentName,  String? examName,  double? examFullMark)  $default,) {final _that = this;
switch (_that) {
case _Mark():
return $default(_that.id,_that.examId,_that.studentId,_that.score,_that.studentName,_that.examName,_that.examFullMark);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int examId,  int studentId,  double score,  String? studentName,  String? examName,  double? examFullMark)?  $default,) {final _that = this;
switch (_that) {
case _Mark() when $default != null:
return $default(_that.id,_that.examId,_that.studentId,_that.score,_that.studentName,_that.examName,_that.examFullMark);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Mark implements Mark {
  const _Mark({this.id, required this.examId, required this.studentId, required this.score, this.studentName, this.examName, this.examFullMark});
  factory _Mark.fromJson(Map<String, dynamic> json) => _$MarkFromJson(json);

@override final  int? id;
@override final  int examId;
@override final  int studentId;
@override final  double score;
/// Populated via join — not stored in marks table
@override final  String? studentName;
/// Populated via join — not stored in marks table
@override final  String? examName;
/// Populated via join — not stored in marks table
@override final  double? examFullMark;

/// Create a copy of Mark
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarkCopyWith<_Mark> get copyWith => __$MarkCopyWithImpl<_Mark>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mark&&(identical(other.id, id) || other.id == id)&&(identical(other.examId, examId) || other.examId == examId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.score, score) || other.score == score)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.examName, examName) || other.examName == examName)&&(identical(other.examFullMark, examFullMark) || other.examFullMark == examFullMark));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,examId,studentId,score,studentName,examName,examFullMark);

@override
String toString() {
  return 'Mark(id: $id, examId: $examId, studentId: $studentId, score: $score, studentName: $studentName, examName: $examName, examFullMark: $examFullMark)';
}


}

/// @nodoc
abstract mixin class _$MarkCopyWith<$Res> implements $MarkCopyWith<$Res> {
  factory _$MarkCopyWith(_Mark value, $Res Function(_Mark) _then) = __$MarkCopyWithImpl;
@override @useResult
$Res call({
 int? id, int examId, int studentId, double score, String? studentName, String? examName, double? examFullMark
});




}
/// @nodoc
class __$MarkCopyWithImpl<$Res>
    implements _$MarkCopyWith<$Res> {
  __$MarkCopyWithImpl(this._self, this._then);

  final _Mark _self;
  final $Res Function(_Mark) _then;

/// Create a copy of Mark
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? examId = null,Object? studentId = null,Object? score = null,Object? studentName = freezed,Object? examName = freezed,Object? examFullMark = freezed,}) {
  return _then(_Mark(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,examId: null == examId ? _self.examId : examId // ignore: cast_nullable_to_non_nullable
as int,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,studentName: freezed == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String?,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,examFullMark: freezed == examFullMark ? _self.examFullMark : examFullMark // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
