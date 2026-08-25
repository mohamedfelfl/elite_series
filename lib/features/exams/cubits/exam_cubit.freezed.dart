// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExamState {

 List<Map<String, dynamic>> get exams; List<Map<String, dynamic>> get marks; List<Map<String, dynamic>> get studentMarks; List<Map<String, dynamic>> get groups; List<Map<String, dynamic>> get groupStudents; Map<String, List<Map<String, dynamic>>> get groupedExamStudents; List<StudentExamResult> get topStudents; double get averageScore; bool get isLoading; String? get error;
/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamStateCopyWith<ExamState> get copyWith => _$ExamStateCopyWithImpl<ExamState>(this as ExamState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamState&&const DeepCollectionEquality().equals(other.exams, exams)&&const DeepCollectionEquality().equals(other.marks, marks)&&const DeepCollectionEquality().equals(other.studentMarks, studentMarks)&&const DeepCollectionEquality().equals(other.groups, groups)&&const DeepCollectionEquality().equals(other.groupStudents, groupStudents)&&const DeepCollectionEquality().equals(other.groupedExamStudents, groupedExamStudents)&&const DeepCollectionEquality().equals(other.topStudents, topStudents)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(exams),const DeepCollectionEquality().hash(marks),const DeepCollectionEquality().hash(studentMarks),const DeepCollectionEquality().hash(groups),const DeepCollectionEquality().hash(groupStudents),const DeepCollectionEquality().hash(groupedExamStudents),const DeepCollectionEquality().hash(topStudents),averageScore,isLoading,error);

@override
String toString() {
  return 'ExamState(exams: $exams, marks: $marks, studentMarks: $studentMarks, groups: $groups, groupStudents: $groupStudents, groupedExamStudents: $groupedExamStudents, topStudents: $topStudents, averageScore: $averageScore, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $ExamStateCopyWith<$Res>  {
  factory $ExamStateCopyWith(ExamState value, $Res Function(ExamState) _then) = _$ExamStateCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> exams, List<Map<String, dynamic>> marks, List<Map<String, dynamic>> studentMarks, List<Map<String, dynamic>> groups, List<Map<String, dynamic>> groupStudents, Map<String, List<Map<String, dynamic>>> groupedExamStudents, List<StudentExamResult> topStudents, double averageScore, bool isLoading, String? error
});




}
/// @nodoc
class _$ExamStateCopyWithImpl<$Res>
    implements $ExamStateCopyWith<$Res> {
  _$ExamStateCopyWithImpl(this._self, this._then);

  final ExamState _self;
  final $Res Function(ExamState) _then;

/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exams = null,Object? marks = null,Object? studentMarks = null,Object? groups = null,Object? groupStudents = null,Object? groupedExamStudents = null,Object? topStudents = null,Object? averageScore = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
exams: null == exams ? _self.exams : exams // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,marks: null == marks ? _self.marks : marks // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,studentMarks: null == studentMarks ? _self.studentMarks : studentMarks // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,groupStudents: null == groupStudents ? _self.groupStudents : groupStudents // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,groupedExamStudents: null == groupedExamStudents ? _self.groupedExamStudents : groupedExamStudents // ignore: cast_nullable_to_non_nullable
as Map<String, List<Map<String, dynamic>>>,topStudents: null == topStudents ? _self.topStudents : topStudents // ignore: cast_nullable_to_non_nullable
as List<StudentExamResult>,averageScore: null == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamState].
extension ExamStatePatterns on ExamState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamState value)  $default,){
final _that = this;
switch (_that) {
case _ExamState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamState value)?  $default,){
final _that = this;
switch (_that) {
case _ExamState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> exams,  List<Map<String, dynamic>> marks,  List<Map<String, dynamic>> studentMarks,  List<Map<String, dynamic>> groups,  List<Map<String, dynamic>> groupStudents,  Map<String, List<Map<String, dynamic>>> groupedExamStudents,  List<StudentExamResult> topStudents,  double averageScore,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamState() when $default != null:
return $default(_that.exams,_that.marks,_that.studentMarks,_that.groups,_that.groupStudents,_that.groupedExamStudents,_that.topStudents,_that.averageScore,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> exams,  List<Map<String, dynamic>> marks,  List<Map<String, dynamic>> studentMarks,  List<Map<String, dynamic>> groups,  List<Map<String, dynamic>> groupStudents,  Map<String, List<Map<String, dynamic>>> groupedExamStudents,  List<StudentExamResult> topStudents,  double averageScore,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ExamState():
return $default(_that.exams,_that.marks,_that.studentMarks,_that.groups,_that.groupStudents,_that.groupedExamStudents,_that.topStudents,_that.averageScore,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> exams,  List<Map<String, dynamic>> marks,  List<Map<String, dynamic>> studentMarks,  List<Map<String, dynamic>> groups,  List<Map<String, dynamic>> groupStudents,  Map<String, List<Map<String, dynamic>>> groupedExamStudents,  List<StudentExamResult> topStudents,  double averageScore,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ExamState() when $default != null:
return $default(_that.exams,_that.marks,_that.studentMarks,_that.groups,_that.groupStudents,_that.groupedExamStudents,_that.topStudents,_that.averageScore,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ExamState implements ExamState {
  const _ExamState({final  List<Map<String, dynamic>> exams = const [], final  List<Map<String, dynamic>> marks = const [], final  List<Map<String, dynamic>> studentMarks = const [], final  List<Map<String, dynamic>> groups = const [], final  List<Map<String, dynamic>> groupStudents = const [], final  Map<String, List<Map<String, dynamic>>> groupedExamStudents = const {}, final  List<StudentExamResult> topStudents = const [], this.averageScore = 0.0, this.isLoading = false, this.error}): _exams = exams,_marks = marks,_studentMarks = studentMarks,_groups = groups,_groupStudents = groupStudents,_groupedExamStudents = groupedExamStudents,_topStudents = topStudents;
  

 final  List<Map<String, dynamic>> _exams;
@override@JsonKey() List<Map<String, dynamic>> get exams {
  if (_exams is EqualUnmodifiableListView) return _exams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exams);
}

 final  List<Map<String, dynamic>> _marks;
@override@JsonKey() List<Map<String, dynamic>> get marks {
  if (_marks is EqualUnmodifiableListView) return _marks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_marks);
}

 final  List<Map<String, dynamic>> _studentMarks;
@override@JsonKey() List<Map<String, dynamic>> get studentMarks {
  if (_studentMarks is EqualUnmodifiableListView) return _studentMarks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_studentMarks);
}

 final  List<Map<String, dynamic>> _groups;
@override@JsonKey() List<Map<String, dynamic>> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  List<Map<String, dynamic>> _groupStudents;
@override@JsonKey() List<Map<String, dynamic>> get groupStudents {
  if (_groupStudents is EqualUnmodifiableListView) return _groupStudents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupStudents);
}

 final  Map<String, List<Map<String, dynamic>>> _groupedExamStudents;
@override@JsonKey() Map<String, List<Map<String, dynamic>>> get groupedExamStudents {
  if (_groupedExamStudents is EqualUnmodifiableMapView) return _groupedExamStudents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groupedExamStudents);
}

 final  List<StudentExamResult> _topStudents;
@override@JsonKey() List<StudentExamResult> get topStudents {
  if (_topStudents is EqualUnmodifiableListView) return _topStudents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topStudents);
}

@override@JsonKey() final  double averageScore;
@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamStateCopyWith<_ExamState> get copyWith => __$ExamStateCopyWithImpl<_ExamState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamState&&const DeepCollectionEquality().equals(other._exams, _exams)&&const DeepCollectionEquality().equals(other._marks, _marks)&&const DeepCollectionEquality().equals(other._studentMarks, _studentMarks)&&const DeepCollectionEquality().equals(other._groups, _groups)&&const DeepCollectionEquality().equals(other._groupStudents, _groupStudents)&&const DeepCollectionEquality().equals(other._groupedExamStudents, _groupedExamStudents)&&const DeepCollectionEquality().equals(other._topStudents, _topStudents)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_exams),const DeepCollectionEquality().hash(_marks),const DeepCollectionEquality().hash(_studentMarks),const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_groupStudents),const DeepCollectionEquality().hash(_groupedExamStudents),const DeepCollectionEquality().hash(_topStudents),averageScore,isLoading,error);

@override
String toString() {
  return 'ExamState(exams: $exams, marks: $marks, studentMarks: $studentMarks, groups: $groups, groupStudents: $groupStudents, groupedExamStudents: $groupedExamStudents, topStudents: $topStudents, averageScore: $averageScore, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ExamStateCopyWith<$Res> implements $ExamStateCopyWith<$Res> {
  factory _$ExamStateCopyWith(_ExamState value, $Res Function(_ExamState) _then) = __$ExamStateCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> exams, List<Map<String, dynamic>> marks, List<Map<String, dynamic>> studentMarks, List<Map<String, dynamic>> groups, List<Map<String, dynamic>> groupStudents, Map<String, List<Map<String, dynamic>>> groupedExamStudents, List<StudentExamResult> topStudents, double averageScore, bool isLoading, String? error
});




}
/// @nodoc
class __$ExamStateCopyWithImpl<$Res>
    implements _$ExamStateCopyWith<$Res> {
  __$ExamStateCopyWithImpl(this._self, this._then);

  final _ExamState _self;
  final $Res Function(_ExamState) _then;

/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exams = null,Object? marks = null,Object? studentMarks = null,Object? groups = null,Object? groupStudents = null,Object? groupedExamStudents = null,Object? topStudents = null,Object? averageScore = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_ExamState(
exams: null == exams ? _self._exams : exams // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,marks: null == marks ? _self._marks : marks // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,studentMarks: null == studentMarks ? _self._studentMarks : studentMarks // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,groupStudents: null == groupStudents ? _self._groupStudents : groupStudents // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,groupedExamStudents: null == groupedExamStudents ? _self._groupedExamStudents : groupedExamStudents // ignore: cast_nullable_to_non_nullable
as Map<String, List<Map<String, dynamic>>>,topStudents: null == topStudents ? _self._topStudents : topStudents // ignore: cast_nullable_to_non_nullable
as List<StudentExamResult>,averageScore: null == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
