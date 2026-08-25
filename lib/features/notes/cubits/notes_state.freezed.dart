// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotesState {

 bool get isLoading; List<Note> get notes; Map<int, bool> get currentDeliveries;// Persistent in DB
 Map<int, bool> get pendingDeliveries;// Draft changes in UI
 int? get selectedNoteId; String? get error; DateTime? get lastSaveTimestamp;
/// Create a copy of NotesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotesStateCopyWith<NotesState> get copyWith => _$NotesStateCopyWithImpl<NotesState>(this as NotesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.notes, notes)&&const DeepCollectionEquality().equals(other.currentDeliveries, currentDeliveries)&&const DeepCollectionEquality().equals(other.pendingDeliveries, pendingDeliveries)&&(identical(other.selectedNoteId, selectedNoteId) || other.selectedNoteId == selectedNoteId)&&(identical(other.error, error) || other.error == error)&&(identical(other.lastSaveTimestamp, lastSaveTimestamp) || other.lastSaveTimestamp == lastSaveTimestamp));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(notes),const DeepCollectionEquality().hash(currentDeliveries),const DeepCollectionEquality().hash(pendingDeliveries),selectedNoteId,error,lastSaveTimestamp);

@override
String toString() {
  return 'NotesState(isLoading: $isLoading, notes: $notes, currentDeliveries: $currentDeliveries, pendingDeliveries: $pendingDeliveries, selectedNoteId: $selectedNoteId, error: $error, lastSaveTimestamp: $lastSaveTimestamp)';
}


}

/// @nodoc
abstract mixin class $NotesStateCopyWith<$Res>  {
  factory $NotesStateCopyWith(NotesState value, $Res Function(NotesState) _then) = _$NotesStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<Note> notes, Map<int, bool> currentDeliveries, Map<int, bool> pendingDeliveries, int? selectedNoteId, String? error, DateTime? lastSaveTimestamp
});




}
/// @nodoc
class _$NotesStateCopyWithImpl<$Res>
    implements $NotesStateCopyWith<$Res> {
  _$NotesStateCopyWithImpl(this._self, this._then);

  final NotesState _self;
  final $Res Function(NotesState) _then;

/// Create a copy of NotesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? notes = null,Object? currentDeliveries = null,Object? pendingDeliveries = null,Object? selectedNoteId = freezed,Object? error = freezed,Object? lastSaveTimestamp = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<Note>,currentDeliveries: null == currentDeliveries ? _self.currentDeliveries : currentDeliveries // ignore: cast_nullable_to_non_nullable
as Map<int, bool>,pendingDeliveries: null == pendingDeliveries ? _self.pendingDeliveries : pendingDeliveries // ignore: cast_nullable_to_non_nullable
as Map<int, bool>,selectedNoteId: freezed == selectedNoteId ? _self.selectedNoteId : selectedNoteId // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,lastSaveTimestamp: freezed == lastSaveTimestamp ? _self.lastSaveTimestamp : lastSaveTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotesState].
extension NotesStatePatterns on NotesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotesState value)  $default,){
final _that = this;
switch (_that) {
case _NotesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotesState value)?  $default,){
final _that = this;
switch (_that) {
case _NotesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<Note> notes,  Map<int, bool> currentDeliveries,  Map<int, bool> pendingDeliveries,  int? selectedNoteId,  String? error,  DateTime? lastSaveTimestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotesState() when $default != null:
return $default(_that.isLoading,_that.notes,_that.currentDeliveries,_that.pendingDeliveries,_that.selectedNoteId,_that.error,_that.lastSaveTimestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<Note> notes,  Map<int, bool> currentDeliveries,  Map<int, bool> pendingDeliveries,  int? selectedNoteId,  String? error,  DateTime? lastSaveTimestamp)  $default,) {final _that = this;
switch (_that) {
case _NotesState():
return $default(_that.isLoading,_that.notes,_that.currentDeliveries,_that.pendingDeliveries,_that.selectedNoteId,_that.error,_that.lastSaveTimestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<Note> notes,  Map<int, bool> currentDeliveries,  Map<int, bool> pendingDeliveries,  int? selectedNoteId,  String? error,  DateTime? lastSaveTimestamp)?  $default,) {final _that = this;
switch (_that) {
case _NotesState() when $default != null:
return $default(_that.isLoading,_that.notes,_that.currentDeliveries,_that.pendingDeliveries,_that.selectedNoteId,_that.error,_that.lastSaveTimestamp);case _:
  return null;

}
}

}

/// @nodoc


class _NotesState implements NotesState {
  const _NotesState({this.isLoading = false, final  List<Note> notes = const [], final  Map<int, bool> currentDeliveries = const {}, final  Map<int, bool> pendingDeliveries = const {}, this.selectedNoteId, this.error, this.lastSaveTimestamp}): _notes = notes,_currentDeliveries = currentDeliveries,_pendingDeliveries = pendingDeliveries;
  

@override@JsonKey() final  bool isLoading;
 final  List<Note> _notes;
@override@JsonKey() List<Note> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

 final  Map<int, bool> _currentDeliveries;
@override@JsonKey() Map<int, bool> get currentDeliveries {
  if (_currentDeliveries is EqualUnmodifiableMapView) return _currentDeliveries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_currentDeliveries);
}

// Persistent in DB
 final  Map<int, bool> _pendingDeliveries;
// Persistent in DB
@override@JsonKey() Map<int, bool> get pendingDeliveries {
  if (_pendingDeliveries is EqualUnmodifiableMapView) return _pendingDeliveries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pendingDeliveries);
}

// Draft changes in UI
@override final  int? selectedNoteId;
@override final  String? error;
@override final  DateTime? lastSaveTimestamp;

/// Create a copy of NotesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotesStateCopyWith<_NotesState> get copyWith => __$NotesStateCopyWithImpl<_NotesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._notes, _notes)&&const DeepCollectionEquality().equals(other._currentDeliveries, _currentDeliveries)&&const DeepCollectionEquality().equals(other._pendingDeliveries, _pendingDeliveries)&&(identical(other.selectedNoteId, selectedNoteId) || other.selectedNoteId == selectedNoteId)&&(identical(other.error, error) || other.error == error)&&(identical(other.lastSaveTimestamp, lastSaveTimestamp) || other.lastSaveTimestamp == lastSaveTimestamp));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_notes),const DeepCollectionEquality().hash(_currentDeliveries),const DeepCollectionEquality().hash(_pendingDeliveries),selectedNoteId,error,lastSaveTimestamp);

@override
String toString() {
  return 'NotesState(isLoading: $isLoading, notes: $notes, currentDeliveries: $currentDeliveries, pendingDeliveries: $pendingDeliveries, selectedNoteId: $selectedNoteId, error: $error, lastSaveTimestamp: $lastSaveTimestamp)';
}


}

/// @nodoc
abstract mixin class _$NotesStateCopyWith<$Res> implements $NotesStateCopyWith<$Res> {
  factory _$NotesStateCopyWith(_NotesState value, $Res Function(_NotesState) _then) = __$NotesStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<Note> notes, Map<int, bool> currentDeliveries, Map<int, bool> pendingDeliveries, int? selectedNoteId, String? error, DateTime? lastSaveTimestamp
});




}
/// @nodoc
class __$NotesStateCopyWithImpl<$Res>
    implements _$NotesStateCopyWith<$Res> {
  __$NotesStateCopyWithImpl(this._self, this._then);

  final _NotesState _self;
  final $Res Function(_NotesState) _then;

/// Create a copy of NotesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? notes = null,Object? currentDeliveries = null,Object? pendingDeliveries = null,Object? selectedNoteId = freezed,Object? error = freezed,Object? lastSaveTimestamp = freezed,}) {
  return _then(_NotesState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<Note>,currentDeliveries: null == currentDeliveries ? _self._currentDeliveries : currentDeliveries // ignore: cast_nullable_to_non_nullable
as Map<int, bool>,pendingDeliveries: null == pendingDeliveries ? _self._pendingDeliveries : pendingDeliveries // ignore: cast_nullable_to_non_nullable
as Map<int, bool>,selectedNoteId: freezed == selectedNoteId ? _self.selectedNoteId : selectedNoteId // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,lastSaveTimestamp: freezed == lastSaveTimestamp ? _self.lastSaveTimestamp : lastSaveTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
