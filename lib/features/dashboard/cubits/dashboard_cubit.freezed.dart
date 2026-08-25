// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 int get totalStudents; int get totalGroups; int get totalAssistants; int get totalExams; double get attendanceRate; double get paymentCollectionRate; int get upcomingExams; List<Map<String, dynamic>> get recentAttendance; List<Map<String, dynamic>> get recentPayments; bool get isLoading; String? get error;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&(identical(other.totalGroups, totalGroups) || other.totalGroups == totalGroups)&&(identical(other.totalAssistants, totalAssistants) || other.totalAssistants == totalAssistants)&&(identical(other.totalExams, totalExams) || other.totalExams == totalExams)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate)&&(identical(other.paymentCollectionRate, paymentCollectionRate) || other.paymentCollectionRate == paymentCollectionRate)&&(identical(other.upcomingExams, upcomingExams) || other.upcomingExams == upcomingExams)&&const DeepCollectionEquality().equals(other.recentAttendance, recentAttendance)&&const DeepCollectionEquality().equals(other.recentPayments, recentPayments)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,totalStudents,totalGroups,totalAssistants,totalExams,attendanceRate,paymentCollectionRate,upcomingExams,const DeepCollectionEquality().hash(recentAttendance),const DeepCollectionEquality().hash(recentPayments),isLoading,error);

@override
String toString() {
  return 'DashboardState(totalStudents: $totalStudents, totalGroups: $totalGroups, totalAssistants: $totalAssistants, totalExams: $totalExams, attendanceRate: $attendanceRate, paymentCollectionRate: $paymentCollectionRate, upcomingExams: $upcomingExams, recentAttendance: $recentAttendance, recentPayments: $recentPayments, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 int totalStudents, int totalGroups, int totalAssistants, int totalExams, double attendanceRate, double paymentCollectionRate, int upcomingExams, List<Map<String, dynamic>> recentAttendance, List<Map<String, dynamic>> recentPayments, bool isLoading, String? error
});




}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalStudents = null,Object? totalGroups = null,Object? totalAssistants = null,Object? totalExams = null,Object? attendanceRate = null,Object? paymentCollectionRate = null,Object? upcomingExams = null,Object? recentAttendance = null,Object? recentPayments = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,totalGroups: null == totalGroups ? _self.totalGroups : totalGroups // ignore: cast_nullable_to_non_nullable
as int,totalAssistants: null == totalAssistants ? _self.totalAssistants : totalAssistants // ignore: cast_nullable_to_non_nullable
as int,totalExams: null == totalExams ? _self.totalExams : totalExams // ignore: cast_nullable_to_non_nullable
as int,attendanceRate: null == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as double,paymentCollectionRate: null == paymentCollectionRate ? _self.paymentCollectionRate : paymentCollectionRate // ignore: cast_nullable_to_non_nullable
as double,upcomingExams: null == upcomingExams ? _self.upcomingExams : upcomingExams // ignore: cast_nullable_to_non_nullable
as int,recentAttendance: null == recentAttendance ? _self.recentAttendance : recentAttendance // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,recentPayments: null == recentPayments ? _self.recentPayments : recentPayments // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalStudents,  int totalGroups,  int totalAssistants,  int totalExams,  double attendanceRate,  double paymentCollectionRate,  int upcomingExams,  List<Map<String, dynamic>> recentAttendance,  List<Map<String, dynamic>> recentPayments,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.totalStudents,_that.totalGroups,_that.totalAssistants,_that.totalExams,_that.attendanceRate,_that.paymentCollectionRate,_that.upcomingExams,_that.recentAttendance,_that.recentPayments,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalStudents,  int totalGroups,  int totalAssistants,  int totalExams,  double attendanceRate,  double paymentCollectionRate,  int upcomingExams,  List<Map<String, dynamic>> recentAttendance,  List<Map<String, dynamic>> recentPayments,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.totalStudents,_that.totalGroups,_that.totalAssistants,_that.totalExams,_that.attendanceRate,_that.paymentCollectionRate,_that.upcomingExams,_that.recentAttendance,_that.recentPayments,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalStudents,  int totalGroups,  int totalAssistants,  int totalExams,  double attendanceRate,  double paymentCollectionRate,  int upcomingExams,  List<Map<String, dynamic>> recentAttendance,  List<Map<String, dynamic>> recentPayments,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.totalStudents,_that.totalGroups,_that.totalAssistants,_that.totalExams,_that.attendanceRate,_that.paymentCollectionRate,_that.upcomingExams,_that.recentAttendance,_that.recentPayments,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState implements DashboardState {
  const _DashboardState({this.totalStudents = 0, this.totalGroups = 0, this.totalAssistants = 0, this.totalExams = 0, this.attendanceRate = 0.0, this.paymentCollectionRate = 0.0, this.upcomingExams = 0, final  List<Map<String, dynamic>> recentAttendance = const [], final  List<Map<String, dynamic>> recentPayments = const [], this.isLoading = false, this.error}): _recentAttendance = recentAttendance,_recentPayments = recentPayments;
  

@override@JsonKey() final  int totalStudents;
@override@JsonKey() final  int totalGroups;
@override@JsonKey() final  int totalAssistants;
@override@JsonKey() final  int totalExams;
@override@JsonKey() final  double attendanceRate;
@override@JsonKey() final  double paymentCollectionRate;
@override@JsonKey() final  int upcomingExams;
 final  List<Map<String, dynamic>> _recentAttendance;
@override@JsonKey() List<Map<String, dynamic>> get recentAttendance {
  if (_recentAttendance is EqualUnmodifiableListView) return _recentAttendance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentAttendance);
}

 final  List<Map<String, dynamic>> _recentPayments;
@override@JsonKey() List<Map<String, dynamic>> get recentPayments {
  if (_recentPayments is EqualUnmodifiableListView) return _recentPayments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentPayments);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&(identical(other.totalGroups, totalGroups) || other.totalGroups == totalGroups)&&(identical(other.totalAssistants, totalAssistants) || other.totalAssistants == totalAssistants)&&(identical(other.totalExams, totalExams) || other.totalExams == totalExams)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate)&&(identical(other.paymentCollectionRate, paymentCollectionRate) || other.paymentCollectionRate == paymentCollectionRate)&&(identical(other.upcomingExams, upcomingExams) || other.upcomingExams == upcomingExams)&&const DeepCollectionEquality().equals(other._recentAttendance, _recentAttendance)&&const DeepCollectionEquality().equals(other._recentPayments, _recentPayments)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,totalStudents,totalGroups,totalAssistants,totalExams,attendanceRate,paymentCollectionRate,upcomingExams,const DeepCollectionEquality().hash(_recentAttendance),const DeepCollectionEquality().hash(_recentPayments),isLoading,error);

@override
String toString() {
  return 'DashboardState(totalStudents: $totalStudents, totalGroups: $totalGroups, totalAssistants: $totalAssistants, totalExams: $totalExams, attendanceRate: $attendanceRate, paymentCollectionRate: $paymentCollectionRate, upcomingExams: $upcomingExams, recentAttendance: $recentAttendance, recentPayments: $recentPayments, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 int totalStudents, int totalGroups, int totalAssistants, int totalExams, double attendanceRate, double paymentCollectionRate, int upcomingExams, List<Map<String, dynamic>> recentAttendance, List<Map<String, dynamic>> recentPayments, bool isLoading, String? error
});




}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalStudents = null,Object? totalGroups = null,Object? totalAssistants = null,Object? totalExams = null,Object? attendanceRate = null,Object? paymentCollectionRate = null,Object? upcomingExams = null,Object? recentAttendance = null,Object? recentPayments = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_DashboardState(
totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,totalGroups: null == totalGroups ? _self.totalGroups : totalGroups // ignore: cast_nullable_to_non_nullable
as int,totalAssistants: null == totalAssistants ? _self.totalAssistants : totalAssistants // ignore: cast_nullable_to_non_nullable
as int,totalExams: null == totalExams ? _self.totalExams : totalExams // ignore: cast_nullable_to_non_nullable
as int,attendanceRate: null == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as double,paymentCollectionRate: null == paymentCollectionRate ? _self.paymentCollectionRate : paymentCollectionRate // ignore: cast_nullable_to_non_nullable
as double,upcomingExams: null == upcomingExams ? _self.upcomingExams : upcomingExams // ignore: cast_nullable_to_non_nullable
as int,recentAttendance: null == recentAttendance ? _self._recentAttendance : recentAttendance // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,recentPayments: null == recentPayments ? _self._recentPayments : recentPayments // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
