// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_card_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrCardState {

 QRCardSelectionMode get selectionMode; String get searchQuery; int? get selectedGroupId; String? get selectedStage; DateTime? get selectedStartDate; DateTime? get selectedEndDate; List<StudentCardData> get allStudents; List<StudentCardData> get filteredStudents; Set<int> get selectedStudentIds; StudentCardData? get activePreviewStudent; List<Map<String, dynamic>> get availableGroups; List<String> get availableStages; bool get isLoading; bool get isExporting; double get exportProgress; String get exportStatusText; String? get error; String? get successMessage;
/// Create a copy of QrCardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrCardStateCopyWith<QrCardState> get copyWith => _$QrCardStateCopyWithImpl<QrCardState>(this as QrCardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrCardState&&(identical(other.selectionMode, selectionMode) || other.selectionMode == selectionMode)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedGroupId, selectedGroupId) || other.selectedGroupId == selectedGroupId)&&(identical(other.selectedStage, selectedStage) || other.selectedStage == selectedStage)&&(identical(other.selectedStartDate, selectedStartDate) || other.selectedStartDate == selectedStartDate)&&(identical(other.selectedEndDate, selectedEndDate) || other.selectedEndDate == selectedEndDate)&&const DeepCollectionEquality().equals(other.allStudents, allStudents)&&const DeepCollectionEquality().equals(other.filteredStudents, filteredStudents)&&const DeepCollectionEquality().equals(other.selectedStudentIds, selectedStudentIds)&&(identical(other.activePreviewStudent, activePreviewStudent) || other.activePreviewStudent == activePreviewStudent)&&const DeepCollectionEquality().equals(other.availableGroups, availableGroups)&&const DeepCollectionEquality().equals(other.availableStages, availableStages)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.exportProgress, exportProgress) || other.exportProgress == exportProgress)&&(identical(other.exportStatusText, exportStatusText) || other.exportStatusText == exportStatusText)&&(identical(other.error, error) || other.error == error)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,selectionMode,searchQuery,selectedGroupId,selectedStage,selectedStartDate,selectedEndDate,const DeepCollectionEquality().hash(allStudents),const DeepCollectionEquality().hash(filteredStudents),const DeepCollectionEquality().hash(selectedStudentIds),activePreviewStudent,const DeepCollectionEquality().hash(availableGroups),const DeepCollectionEquality().hash(availableStages),isLoading,isExporting,exportProgress,exportStatusText,error,successMessage);

@override
String toString() {
  return 'QrCardState(selectionMode: $selectionMode, searchQuery: $searchQuery, selectedGroupId: $selectedGroupId, selectedStage: $selectedStage, selectedStartDate: $selectedStartDate, selectedEndDate: $selectedEndDate, allStudents: $allStudents, filteredStudents: $filteredStudents, selectedStudentIds: $selectedStudentIds, activePreviewStudent: $activePreviewStudent, availableGroups: $availableGroups, availableStages: $availableStages, isLoading: $isLoading, isExporting: $isExporting, exportProgress: $exportProgress, exportStatusText: $exportStatusText, error: $error, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $QrCardStateCopyWith<$Res>  {
  factory $QrCardStateCopyWith(QrCardState value, $Res Function(QrCardState) _then) = _$QrCardStateCopyWithImpl;
@useResult
$Res call({
 QRCardSelectionMode selectionMode, String searchQuery, int? selectedGroupId, String? selectedStage, DateTime? selectedStartDate, DateTime? selectedEndDate, List<StudentCardData> allStudents, List<StudentCardData> filteredStudents, Set<int> selectedStudentIds, StudentCardData? activePreviewStudent, List<Map<String, dynamic>> availableGroups, List<String> availableStages, bool isLoading, bool isExporting, double exportProgress, String exportStatusText, String? error, String? successMessage
});


$StudentCardDataCopyWith<$Res>? get activePreviewStudent;

}
/// @nodoc
class _$QrCardStateCopyWithImpl<$Res>
    implements $QrCardStateCopyWith<$Res> {
  _$QrCardStateCopyWithImpl(this._self, this._then);

  final QrCardState _self;
  final $Res Function(QrCardState) _then;

/// Create a copy of QrCardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectionMode = null,Object? searchQuery = null,Object? selectedGroupId = freezed,Object? selectedStage = freezed,Object? selectedStartDate = freezed,Object? selectedEndDate = freezed,Object? allStudents = null,Object? filteredStudents = null,Object? selectedStudentIds = null,Object? activePreviewStudent = freezed,Object? availableGroups = null,Object? availableStages = null,Object? isLoading = null,Object? isExporting = null,Object? exportProgress = null,Object? exportStatusText = null,Object? error = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
selectionMode: null == selectionMode ? _self.selectionMode : selectionMode // ignore: cast_nullable_to_non_nullable
as QRCardSelectionMode,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedGroupId: freezed == selectedGroupId ? _self.selectedGroupId : selectedGroupId // ignore: cast_nullable_to_non_nullable
as int?,selectedStage: freezed == selectedStage ? _self.selectedStage : selectedStage // ignore: cast_nullable_to_non_nullable
as String?,selectedStartDate: freezed == selectedStartDate ? _self.selectedStartDate : selectedStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedEndDate: freezed == selectedEndDate ? _self.selectedEndDate : selectedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,allStudents: null == allStudents ? _self.allStudents : allStudents // ignore: cast_nullable_to_non_nullable
as List<StudentCardData>,filteredStudents: null == filteredStudents ? _self.filteredStudents : filteredStudents // ignore: cast_nullable_to_non_nullable
as List<StudentCardData>,selectedStudentIds: null == selectedStudentIds ? _self.selectedStudentIds : selectedStudentIds // ignore: cast_nullable_to_non_nullable
as Set<int>,activePreviewStudent: freezed == activePreviewStudent ? _self.activePreviewStudent : activePreviewStudent // ignore: cast_nullable_to_non_nullable
as StudentCardData?,availableGroups: null == availableGroups ? _self.availableGroups : availableGroups // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,availableStages: null == availableStages ? _self.availableStages : availableStages // ignore: cast_nullable_to_non_nullable
as List<String>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,exportProgress: null == exportProgress ? _self.exportProgress : exportProgress // ignore: cast_nullable_to_non_nullable
as double,exportStatusText: null == exportStatusText ? _self.exportStatusText : exportStatusText // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of QrCardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentCardDataCopyWith<$Res>? get activePreviewStudent {
    if (_self.activePreviewStudent == null) {
    return null;
  }

  return $StudentCardDataCopyWith<$Res>(_self.activePreviewStudent!, (value) {
    return _then(_self.copyWith(activePreviewStudent: value));
  });
}
}


/// Adds pattern-matching-related methods to [QrCardState].
extension QrCardStatePatterns on QrCardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrCardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrCardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrCardState value)  $default,){
final _that = this;
switch (_that) {
case _QrCardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrCardState value)?  $default,){
final _that = this;
switch (_that) {
case _QrCardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QRCardSelectionMode selectionMode,  String searchQuery,  int? selectedGroupId,  String? selectedStage,  DateTime? selectedStartDate,  DateTime? selectedEndDate,  List<StudentCardData> allStudents,  List<StudentCardData> filteredStudents,  Set<int> selectedStudentIds,  StudentCardData? activePreviewStudent,  List<Map<String, dynamic>> availableGroups,  List<String> availableStages,  bool isLoading,  bool isExporting,  double exportProgress,  String exportStatusText,  String? error,  String? successMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrCardState() when $default != null:
return $default(_that.selectionMode,_that.searchQuery,_that.selectedGroupId,_that.selectedStage,_that.selectedStartDate,_that.selectedEndDate,_that.allStudents,_that.filteredStudents,_that.selectedStudentIds,_that.activePreviewStudent,_that.availableGroups,_that.availableStages,_that.isLoading,_that.isExporting,_that.exportProgress,_that.exportStatusText,_that.error,_that.successMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QRCardSelectionMode selectionMode,  String searchQuery,  int? selectedGroupId,  String? selectedStage,  DateTime? selectedStartDate,  DateTime? selectedEndDate,  List<StudentCardData> allStudents,  List<StudentCardData> filteredStudents,  Set<int> selectedStudentIds,  StudentCardData? activePreviewStudent,  List<Map<String, dynamic>> availableGroups,  List<String> availableStages,  bool isLoading,  bool isExporting,  double exportProgress,  String exportStatusText,  String? error,  String? successMessage)  $default,) {final _that = this;
switch (_that) {
case _QrCardState():
return $default(_that.selectionMode,_that.searchQuery,_that.selectedGroupId,_that.selectedStage,_that.selectedStartDate,_that.selectedEndDate,_that.allStudents,_that.filteredStudents,_that.selectedStudentIds,_that.activePreviewStudent,_that.availableGroups,_that.availableStages,_that.isLoading,_that.isExporting,_that.exportProgress,_that.exportStatusText,_that.error,_that.successMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QRCardSelectionMode selectionMode,  String searchQuery,  int? selectedGroupId,  String? selectedStage,  DateTime? selectedStartDate,  DateTime? selectedEndDate,  List<StudentCardData> allStudents,  List<StudentCardData> filteredStudents,  Set<int> selectedStudentIds,  StudentCardData? activePreviewStudent,  List<Map<String, dynamic>> availableGroups,  List<String> availableStages,  bool isLoading,  bool isExporting,  double exportProgress,  String exportStatusText,  String? error,  String? successMessage)?  $default,) {final _that = this;
switch (_that) {
case _QrCardState() when $default != null:
return $default(_that.selectionMode,_that.searchQuery,_that.selectedGroupId,_that.selectedStage,_that.selectedStartDate,_that.selectedEndDate,_that.allStudents,_that.filteredStudents,_that.selectedStudentIds,_that.activePreviewStudent,_that.availableGroups,_that.availableStages,_that.isLoading,_that.isExporting,_that.exportProgress,_that.exportStatusText,_that.error,_that.successMessage);case _:
  return null;

}
}

}

/// @nodoc


class _QrCardState implements QrCardState {
  const _QrCardState({this.selectionMode = QRCardSelectionMode.student, this.searchQuery = '', this.selectedGroupId, this.selectedStage, this.selectedStartDate, this.selectedEndDate, final  List<StudentCardData> allStudents = const [], final  List<StudentCardData> filteredStudents = const [], final  Set<int> selectedStudentIds = const {}, this.activePreviewStudent, final  List<Map<String, dynamic>> availableGroups = const [], final  List<String> availableStages = const [], this.isLoading = false, this.isExporting = false, this.exportProgress = 0.0, this.exportStatusText = '', this.error, this.successMessage}): _allStudents = allStudents,_filteredStudents = filteredStudents,_selectedStudentIds = selectedStudentIds,_availableGroups = availableGroups,_availableStages = availableStages;
  

@override@JsonKey() final  QRCardSelectionMode selectionMode;
@override@JsonKey() final  String searchQuery;
@override final  int? selectedGroupId;
@override final  String? selectedStage;
@override final  DateTime? selectedStartDate;
@override final  DateTime? selectedEndDate;
 final  List<StudentCardData> _allStudents;
@override@JsonKey() List<StudentCardData> get allStudents {
  if (_allStudents is EqualUnmodifiableListView) return _allStudents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allStudents);
}

 final  List<StudentCardData> _filteredStudents;
@override@JsonKey() List<StudentCardData> get filteredStudents {
  if (_filteredStudents is EqualUnmodifiableListView) return _filteredStudents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredStudents);
}

 final  Set<int> _selectedStudentIds;
@override@JsonKey() Set<int> get selectedStudentIds {
  if (_selectedStudentIds is EqualUnmodifiableSetView) return _selectedStudentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedStudentIds);
}

@override final  StudentCardData? activePreviewStudent;
 final  List<Map<String, dynamic>> _availableGroups;
@override@JsonKey() List<Map<String, dynamic>> get availableGroups {
  if (_availableGroups is EqualUnmodifiableListView) return _availableGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableGroups);
}

 final  List<String> _availableStages;
@override@JsonKey() List<String> get availableStages {
  if (_availableStages is EqualUnmodifiableListView) return _availableStages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableStages);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isExporting;
@override@JsonKey() final  double exportProgress;
@override@JsonKey() final  String exportStatusText;
@override final  String? error;
@override final  String? successMessage;

/// Create a copy of QrCardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrCardStateCopyWith<_QrCardState> get copyWith => __$QrCardStateCopyWithImpl<_QrCardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrCardState&&(identical(other.selectionMode, selectionMode) || other.selectionMode == selectionMode)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedGroupId, selectedGroupId) || other.selectedGroupId == selectedGroupId)&&(identical(other.selectedStage, selectedStage) || other.selectedStage == selectedStage)&&(identical(other.selectedStartDate, selectedStartDate) || other.selectedStartDate == selectedStartDate)&&(identical(other.selectedEndDate, selectedEndDate) || other.selectedEndDate == selectedEndDate)&&const DeepCollectionEquality().equals(other._allStudents, _allStudents)&&const DeepCollectionEquality().equals(other._filteredStudents, _filteredStudents)&&const DeepCollectionEquality().equals(other._selectedStudentIds, _selectedStudentIds)&&(identical(other.activePreviewStudent, activePreviewStudent) || other.activePreviewStudent == activePreviewStudent)&&const DeepCollectionEquality().equals(other._availableGroups, _availableGroups)&&const DeepCollectionEquality().equals(other._availableStages, _availableStages)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.exportProgress, exportProgress) || other.exportProgress == exportProgress)&&(identical(other.exportStatusText, exportStatusText) || other.exportStatusText == exportStatusText)&&(identical(other.error, error) || other.error == error)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,selectionMode,searchQuery,selectedGroupId,selectedStage,selectedStartDate,selectedEndDate,const DeepCollectionEquality().hash(_allStudents),const DeepCollectionEquality().hash(_filteredStudents),const DeepCollectionEquality().hash(_selectedStudentIds),activePreviewStudent,const DeepCollectionEquality().hash(_availableGroups),const DeepCollectionEquality().hash(_availableStages),isLoading,isExporting,exportProgress,exportStatusText,error,successMessage);

@override
String toString() {
  return 'QrCardState(selectionMode: $selectionMode, searchQuery: $searchQuery, selectedGroupId: $selectedGroupId, selectedStage: $selectedStage, selectedStartDate: $selectedStartDate, selectedEndDate: $selectedEndDate, allStudents: $allStudents, filteredStudents: $filteredStudents, selectedStudentIds: $selectedStudentIds, activePreviewStudent: $activePreviewStudent, availableGroups: $availableGroups, availableStages: $availableStages, isLoading: $isLoading, isExporting: $isExporting, exportProgress: $exportProgress, exportStatusText: $exportStatusText, error: $error, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$QrCardStateCopyWith<$Res> implements $QrCardStateCopyWith<$Res> {
  factory _$QrCardStateCopyWith(_QrCardState value, $Res Function(_QrCardState) _then) = __$QrCardStateCopyWithImpl;
@override @useResult
$Res call({
 QRCardSelectionMode selectionMode, String searchQuery, int? selectedGroupId, String? selectedStage, DateTime? selectedStartDate, DateTime? selectedEndDate, List<StudentCardData> allStudents, List<StudentCardData> filteredStudents, Set<int> selectedStudentIds, StudentCardData? activePreviewStudent, List<Map<String, dynamic>> availableGroups, List<String> availableStages, bool isLoading, bool isExporting, double exportProgress, String exportStatusText, String? error, String? successMessage
});


@override $StudentCardDataCopyWith<$Res>? get activePreviewStudent;

}
/// @nodoc
class __$QrCardStateCopyWithImpl<$Res>
    implements _$QrCardStateCopyWith<$Res> {
  __$QrCardStateCopyWithImpl(this._self, this._then);

  final _QrCardState _self;
  final $Res Function(_QrCardState) _then;

/// Create a copy of QrCardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectionMode = null,Object? searchQuery = null,Object? selectedGroupId = freezed,Object? selectedStage = freezed,Object? selectedStartDate = freezed,Object? selectedEndDate = freezed,Object? allStudents = null,Object? filteredStudents = null,Object? selectedStudentIds = null,Object? activePreviewStudent = freezed,Object? availableGroups = null,Object? availableStages = null,Object? isLoading = null,Object? isExporting = null,Object? exportProgress = null,Object? exportStatusText = null,Object? error = freezed,Object? successMessage = freezed,}) {
  return _then(_QrCardState(
selectionMode: null == selectionMode ? _self.selectionMode : selectionMode // ignore: cast_nullable_to_non_nullable
as QRCardSelectionMode,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedGroupId: freezed == selectedGroupId ? _self.selectedGroupId : selectedGroupId // ignore: cast_nullable_to_non_nullable
as int?,selectedStage: freezed == selectedStage ? _self.selectedStage : selectedStage // ignore: cast_nullable_to_non_nullable
as String?,selectedStartDate: freezed == selectedStartDate ? _self.selectedStartDate : selectedStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedEndDate: freezed == selectedEndDate ? _self.selectedEndDate : selectedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,allStudents: null == allStudents ? _self._allStudents : allStudents // ignore: cast_nullable_to_non_nullable
as List<StudentCardData>,filteredStudents: null == filteredStudents ? _self._filteredStudents : filteredStudents // ignore: cast_nullable_to_non_nullable
as List<StudentCardData>,selectedStudentIds: null == selectedStudentIds ? _self._selectedStudentIds : selectedStudentIds // ignore: cast_nullable_to_non_nullable
as Set<int>,activePreviewStudent: freezed == activePreviewStudent ? _self.activePreviewStudent : activePreviewStudent // ignore: cast_nullable_to_non_nullable
as StudentCardData?,availableGroups: null == availableGroups ? _self._availableGroups : availableGroups // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,availableStages: null == availableStages ? _self._availableStages : availableStages // ignore: cast_nullable_to_non_nullable
as List<String>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,exportProgress: null == exportProgress ? _self.exportProgress : exportProgress // ignore: cast_nullable_to_non_nullable
as double,exportStatusText: null == exportStatusText ? _self.exportStatusText : exportStatusText // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of QrCardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentCardDataCopyWith<$Res>? get activePreviewStudent {
    if (_self.activePreviewStudent == null) {
    return null;
  }

  return $StudentCardDataCopyWith<$Res>(_self.activePreviewStudent!, (value) {
    return _then(_self.copyWith(activePreviewStudent: value));
  });
}
}

// dart format on
