// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudentState {

 List<Map<String, dynamic>> get students; bool get isLoading; String get searchQuery; int get totalCount; Set<int> get selectedIds; int? get selectedGroupId; String? get error;
/// Create a copy of StudentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentStateCopyWith<StudentState> get copyWith => _$StudentStateCopyWithImpl<StudentState>(this as StudentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentState&&const DeepCollectionEquality().equals(other.students, students)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.selectedIds, selectedIds)&&(identical(other.selectedGroupId, selectedGroupId) || other.selectedGroupId == selectedGroupId)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(students),isLoading,searchQuery,totalCount,const DeepCollectionEquality().hash(selectedIds),selectedGroupId,error);

@override
String toString() {
  return 'StudentState(students: $students, isLoading: $isLoading, searchQuery: $searchQuery, totalCount: $totalCount, selectedIds: $selectedIds, selectedGroupId: $selectedGroupId, error: $error)';
}


}

/// @nodoc
abstract mixin class $StudentStateCopyWith<$Res>  {
  factory $StudentStateCopyWith(StudentState value, $Res Function(StudentState) _then) = _$StudentStateCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> students, bool isLoading, String searchQuery, int totalCount, Set<int> selectedIds, int? selectedGroupId, String? error
});




}
/// @nodoc
class _$StudentStateCopyWithImpl<$Res>
    implements $StudentStateCopyWith<$Res> {
  _$StudentStateCopyWithImpl(this._self, this._then);

  final StudentState _self;
  final $Res Function(StudentState) _then;

/// Create a copy of StudentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? students = null,Object? isLoading = null,Object? searchQuery = null,Object? totalCount = null,Object? selectedIds = null,Object? selectedGroupId = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
students: null == students ? _self.students : students // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,selectedIds: null == selectedIds ? _self.selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<int>,selectedGroupId: freezed == selectedGroupId ? _self.selectedGroupId : selectedGroupId // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentState].
extension StudentStatePatterns on StudentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentState value)  $default,){
final _that = this;
switch (_that) {
case _StudentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentState value)?  $default,){
final _that = this;
switch (_that) {
case _StudentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> students,  bool isLoading,  String searchQuery,  int totalCount,  Set<int> selectedIds,  int? selectedGroupId,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentState() when $default != null:
return $default(_that.students,_that.isLoading,_that.searchQuery,_that.totalCount,_that.selectedIds,_that.selectedGroupId,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> students,  bool isLoading,  String searchQuery,  int totalCount,  Set<int> selectedIds,  int? selectedGroupId,  String? error)  $default,) {final _that = this;
switch (_that) {
case _StudentState():
return $default(_that.students,_that.isLoading,_that.searchQuery,_that.totalCount,_that.selectedIds,_that.selectedGroupId,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> students,  bool isLoading,  String searchQuery,  int totalCount,  Set<int> selectedIds,  int? selectedGroupId,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _StudentState() when $default != null:
return $default(_that.students,_that.isLoading,_that.searchQuery,_that.totalCount,_that.selectedIds,_that.selectedGroupId,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _StudentState implements StudentState {
  const _StudentState({final  List<Map<String, dynamic>> students = const [], this.isLoading = false, this.searchQuery = '', this.totalCount = 0, final  Set<int> selectedIds = const {}, this.selectedGroupId, this.error}): _students = students,_selectedIds = selectedIds;
  

 final  List<Map<String, dynamic>> _students;
@override@JsonKey() List<Map<String, dynamic>> get students {
  if (_students is EqualUnmodifiableListView) return _students;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_students);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  int totalCount;
 final  Set<int> _selectedIds;
@override@JsonKey() Set<int> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}

@override final  int? selectedGroupId;
@override final  String? error;

/// Create a copy of StudentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentStateCopyWith<_StudentState> get copyWith => __$StudentStateCopyWithImpl<_StudentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentState&&const DeepCollectionEquality().equals(other._students, _students)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds)&&(identical(other.selectedGroupId, selectedGroupId) || other.selectedGroupId == selectedGroupId)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_students),isLoading,searchQuery,totalCount,const DeepCollectionEquality().hash(_selectedIds),selectedGroupId,error);

@override
String toString() {
  return 'StudentState(students: $students, isLoading: $isLoading, searchQuery: $searchQuery, totalCount: $totalCount, selectedIds: $selectedIds, selectedGroupId: $selectedGroupId, error: $error)';
}


}

/// @nodoc
abstract mixin class _$StudentStateCopyWith<$Res> implements $StudentStateCopyWith<$Res> {
  factory _$StudentStateCopyWith(_StudentState value, $Res Function(_StudentState) _then) = __$StudentStateCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> students, bool isLoading, String searchQuery, int totalCount, Set<int> selectedIds, int? selectedGroupId, String? error
});




}
/// @nodoc
class __$StudentStateCopyWithImpl<$Res>
    implements _$StudentStateCopyWith<$Res> {
  __$StudentStateCopyWithImpl(this._self, this._then);

  final _StudentState _self;
  final $Res Function(_StudentState) _then;

/// Create a copy of StudentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? students = null,Object? isLoading = null,Object? searchQuery = null,Object? totalCount = null,Object? selectedIds = null,Object? selectedGroupId = freezed,Object? error = freezed,}) {
  return _then(_StudentState(
students: null == students ? _self._students : students // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<int>,selectedGroupId: freezed == selectedGroupId ? _self.selectedGroupId : selectedGroupId // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
