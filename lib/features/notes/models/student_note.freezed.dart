// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentNote {

 int? get id; int get studentId; int get noteId; DateTime? get deliveredDate;
/// Create a copy of StudentNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentNoteCopyWith<StudentNote> get copyWith => _$StudentNoteCopyWithImpl<StudentNote>(this as StudentNote, _$identity);

  /// Serializes this StudentNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentNote&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.deliveredDate, deliveredDate) || other.deliveredDate == deliveredDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,noteId,deliveredDate);

@override
String toString() {
  return 'StudentNote(id: $id, studentId: $studentId, noteId: $noteId, deliveredDate: $deliveredDate)';
}


}

/// @nodoc
abstract mixin class $StudentNoteCopyWith<$Res>  {
  factory $StudentNoteCopyWith(StudentNote value, $Res Function(StudentNote) _then) = _$StudentNoteCopyWithImpl;
@useResult
$Res call({
 int? id, int studentId, int noteId, DateTime? deliveredDate
});




}
/// @nodoc
class _$StudentNoteCopyWithImpl<$Res>
    implements $StudentNoteCopyWith<$Res> {
  _$StudentNoteCopyWithImpl(this._self, this._then);

  final StudentNote _self;
  final $Res Function(StudentNote) _then;

/// Create a copy of StudentNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? studentId = null,Object? noteId = null,Object? deliveredDate = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as int,deliveredDate: freezed == deliveredDate ? _self.deliveredDate : deliveredDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentNote].
extension StudentNotePatterns on StudentNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentNote value)  $default,){
final _that = this;
switch (_that) {
case _StudentNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentNote value)?  $default,){
final _that = this;
switch (_that) {
case _StudentNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int studentId,  int noteId,  DateTime? deliveredDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentNote() when $default != null:
return $default(_that.id,_that.studentId,_that.noteId,_that.deliveredDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int studentId,  int noteId,  DateTime? deliveredDate)  $default,) {final _that = this;
switch (_that) {
case _StudentNote():
return $default(_that.id,_that.studentId,_that.noteId,_that.deliveredDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int studentId,  int noteId,  DateTime? deliveredDate)?  $default,) {final _that = this;
switch (_that) {
case _StudentNote() when $default != null:
return $default(_that.id,_that.studentId,_that.noteId,_that.deliveredDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentNote implements StudentNote {
  const _StudentNote({this.id, required this.studentId, required this.noteId, this.deliveredDate});
  factory _StudentNote.fromJson(Map<String, dynamic> json) => _$StudentNoteFromJson(json);

@override final  int? id;
@override final  int studentId;
@override final  int noteId;
@override final  DateTime? deliveredDate;

/// Create a copy of StudentNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentNoteCopyWith<_StudentNote> get copyWith => __$StudentNoteCopyWithImpl<_StudentNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentNote&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.deliveredDate, deliveredDate) || other.deliveredDate == deliveredDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,noteId,deliveredDate);

@override
String toString() {
  return 'StudentNote(id: $id, studentId: $studentId, noteId: $noteId, deliveredDate: $deliveredDate)';
}


}

/// @nodoc
abstract mixin class _$StudentNoteCopyWith<$Res> implements $StudentNoteCopyWith<$Res> {
  factory _$StudentNoteCopyWith(_StudentNote value, $Res Function(_StudentNote) _then) = __$StudentNoteCopyWithImpl;
@override @useResult
$Res call({
 int? id, int studentId, int noteId, DateTime? deliveredDate
});




}
/// @nodoc
class __$StudentNoteCopyWithImpl<$Res>
    implements _$StudentNoteCopyWith<$Res> {
  __$StudentNoteCopyWithImpl(this._self, this._then);

  final _StudentNote _self;
  final $Res Function(_StudentNote) _then;

/// Create a copy of StudentNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? studentId = null,Object? noteId = null,Object? deliveredDate = freezed,}) {
  return _then(_StudentNote(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as int,deliveredDate: freezed == deliveredDate ? _self.deliveredDate : deliveredDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
