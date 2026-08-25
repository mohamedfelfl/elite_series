// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Exam {

 int? get id; String get name; double get fullMark; DateTime get date;
/// Create a copy of Exam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamCopyWith<Exam> get copyWith => _$ExamCopyWithImpl<Exam>(this as Exam, _$identity);

  /// Serializes this Exam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exam&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.fullMark, fullMark) || other.fullMark == fullMark)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,fullMark,date);

@override
String toString() {
  return 'Exam(id: $id, name: $name, fullMark: $fullMark, date: $date)';
}


}

/// @nodoc
abstract mixin class $ExamCopyWith<$Res>  {
  factory $ExamCopyWith(Exam value, $Res Function(Exam) _then) = _$ExamCopyWithImpl;
@useResult
$Res call({
 int? id, String name, double fullMark, DateTime date
});




}
/// @nodoc
class _$ExamCopyWithImpl<$Res>
    implements $ExamCopyWith<$Res> {
  _$ExamCopyWithImpl(this._self, this._then);

  final Exam _self;
  final $Res Function(Exam) _then;

/// Create a copy of Exam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? fullMark = null,Object? date = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fullMark: null == fullMark ? _self.fullMark : fullMark // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Exam].
extension ExamPatterns on Exam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exam value)  $default,){
final _that = this;
switch (_that) {
case _Exam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exam value)?  $default,){
final _that = this;
switch (_that) {
case _Exam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  double fullMark,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exam() when $default != null:
return $default(_that.id,_that.name,_that.fullMark,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  double fullMark,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _Exam():
return $default(_that.id,_that.name,_that.fullMark,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  double fullMark,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _Exam() when $default != null:
return $default(_that.id,_that.name,_that.fullMark,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exam implements Exam {
  const _Exam({this.id, required this.name, required this.fullMark, required this.date});
  factory _Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

@override final  int? id;
@override final  String name;
@override final  double fullMark;
@override final  DateTime date;

/// Create a copy of Exam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamCopyWith<_Exam> get copyWith => __$ExamCopyWithImpl<_Exam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exam&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.fullMark, fullMark) || other.fullMark == fullMark)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,fullMark,date);

@override
String toString() {
  return 'Exam(id: $id, name: $name, fullMark: $fullMark, date: $date)';
}


}

/// @nodoc
abstract mixin class _$ExamCopyWith<$Res> implements $ExamCopyWith<$Res> {
  factory _$ExamCopyWith(_Exam value, $Res Function(_Exam) _then) = __$ExamCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, double fullMark, DateTime date
});




}
/// @nodoc
class __$ExamCopyWithImpl<$Res>
    implements _$ExamCopyWith<$Res> {
  __$ExamCopyWithImpl(this._self, this._then);

  final _Exam _self;
  final $Res Function(_Exam) _then;

/// Create a copy of Exam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? fullMark = null,Object? date = null,}) {
  return _then(_Exam(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fullMark: null == fullMark ? _self.fullMark : fullMark // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
