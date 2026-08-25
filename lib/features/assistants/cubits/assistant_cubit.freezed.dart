// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssistantState {

 List<Map<String, dynamic>> get assistants; bool get isLoading; String get searchQuery; int get totalCount; Set<int> get selectedIds; String? get error;
/// Create a copy of AssistantState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantStateCopyWith<AssistantState> get copyWith => _$AssistantStateCopyWithImpl<AssistantState>(this as AssistantState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantState&&const DeepCollectionEquality().equals(other.assistants, assistants)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.selectedIds, selectedIds)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(assistants),isLoading,searchQuery,totalCount,const DeepCollectionEquality().hash(selectedIds),error);

@override
String toString() {
  return 'AssistantState(assistants: $assistants, isLoading: $isLoading, searchQuery: $searchQuery, totalCount: $totalCount, selectedIds: $selectedIds, error: $error)';
}


}

/// @nodoc
abstract mixin class $AssistantStateCopyWith<$Res>  {
  factory $AssistantStateCopyWith(AssistantState value, $Res Function(AssistantState) _then) = _$AssistantStateCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> assistants, bool isLoading, String searchQuery, int totalCount, Set<int> selectedIds, String? error
});




}
/// @nodoc
class _$AssistantStateCopyWithImpl<$Res>
    implements $AssistantStateCopyWith<$Res> {
  _$AssistantStateCopyWithImpl(this._self, this._then);

  final AssistantState _self;
  final $Res Function(AssistantState) _then;

/// Create a copy of AssistantState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assistants = null,Object? isLoading = null,Object? searchQuery = null,Object? totalCount = null,Object? selectedIds = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
assistants: null == assistants ? _self.assistants : assistants // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,selectedIds: null == selectedIds ? _self.selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<int>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantState].
extension AssistantStatePatterns on AssistantState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantState value)  $default,){
final _that = this;
switch (_that) {
case _AssistantState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantState value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> assistants,  bool isLoading,  String searchQuery,  int totalCount,  Set<int> selectedIds,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantState() when $default != null:
return $default(_that.assistants,_that.isLoading,_that.searchQuery,_that.totalCount,_that.selectedIds,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> assistants,  bool isLoading,  String searchQuery,  int totalCount,  Set<int> selectedIds,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AssistantState():
return $default(_that.assistants,_that.isLoading,_that.searchQuery,_that.totalCount,_that.selectedIds,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> assistants,  bool isLoading,  String searchQuery,  int totalCount,  Set<int> selectedIds,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AssistantState() when $default != null:
return $default(_that.assistants,_that.isLoading,_that.searchQuery,_that.totalCount,_that.selectedIds,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AssistantState implements AssistantState {
  const _AssistantState({final  List<Map<String, dynamic>> assistants = const [], this.isLoading = false, this.searchQuery = '', this.totalCount = 0, final  Set<int> selectedIds = const {}, this.error}): _assistants = assistants,_selectedIds = selectedIds;
  

 final  List<Map<String, dynamic>> _assistants;
@override@JsonKey() List<Map<String, dynamic>> get assistants {
  if (_assistants is EqualUnmodifiableListView) return _assistants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assistants);
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

@override final  String? error;

/// Create a copy of AssistantState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantStateCopyWith<_AssistantState> get copyWith => __$AssistantStateCopyWithImpl<_AssistantState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantState&&const DeepCollectionEquality().equals(other._assistants, _assistants)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_assistants),isLoading,searchQuery,totalCount,const DeepCollectionEquality().hash(_selectedIds),error);

@override
String toString() {
  return 'AssistantState(assistants: $assistants, isLoading: $isLoading, searchQuery: $searchQuery, totalCount: $totalCount, selectedIds: $selectedIds, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AssistantStateCopyWith<$Res> implements $AssistantStateCopyWith<$Res> {
  factory _$AssistantStateCopyWith(_AssistantState value, $Res Function(_AssistantState) _then) = __$AssistantStateCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> assistants, bool isLoading, String searchQuery, int totalCount, Set<int> selectedIds, String? error
});




}
/// @nodoc
class __$AssistantStateCopyWithImpl<$Res>
    implements _$AssistantStateCopyWith<$Res> {
  __$AssistantStateCopyWithImpl(this._self, this._then);

  final _AssistantState _self;
  final $Res Function(_AssistantState) _then;

/// Create a copy of AssistantState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assistants = null,Object? isLoading = null,Object? searchQuery = null,Object? totalCount = null,Object? selectedIds = null,Object? error = freezed,}) {
  return _then(_AssistantState(
assistants: null == assistants ? _self._assistants : assistants // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<int>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
