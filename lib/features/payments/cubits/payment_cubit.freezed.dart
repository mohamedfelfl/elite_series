// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentState {

 List<Map<String, dynamic>> get payments; List<Map<String, dynamic>> get dailyPayments; bool get isLoading; double get totalSurplus; String? get error;
/// Create a copy of PaymentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentStateCopyWith<PaymentState> get copyWith => _$PaymentStateCopyWithImpl<PaymentState>(this as PaymentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentState&&const DeepCollectionEquality().equals(other.payments, payments)&&const DeepCollectionEquality().equals(other.dailyPayments, dailyPayments)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.totalSurplus, totalSurplus) || other.totalSurplus == totalSurplus)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(payments),const DeepCollectionEquality().hash(dailyPayments),isLoading,totalSurplus,error);

@override
String toString() {
  return 'PaymentState(payments: $payments, dailyPayments: $dailyPayments, isLoading: $isLoading, totalSurplus: $totalSurplus, error: $error)';
}


}

/// @nodoc
abstract mixin class $PaymentStateCopyWith<$Res>  {
  factory $PaymentStateCopyWith(PaymentState value, $Res Function(PaymentState) _then) = _$PaymentStateCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> payments, List<Map<String, dynamic>> dailyPayments, bool isLoading, double totalSurplus, String? error
});




}
/// @nodoc
class _$PaymentStateCopyWithImpl<$Res>
    implements $PaymentStateCopyWith<$Res> {
  _$PaymentStateCopyWithImpl(this._self, this._then);

  final PaymentState _self;
  final $Res Function(PaymentState) _then;

/// Create a copy of PaymentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payments = null,Object? dailyPayments = null,Object? isLoading = null,Object? totalSurplus = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,dailyPayments: null == dailyPayments ? _self.dailyPayments : dailyPayments // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,totalSurplus: null == totalSurplus ? _self.totalSurplus : totalSurplus // ignore: cast_nullable_to_non_nullable
as double,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentState].
extension PaymentStatePatterns on PaymentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentState value)  $default,){
final _that = this;
switch (_that) {
case _PaymentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentState value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> payments,  List<Map<String, dynamic>> dailyPayments,  bool isLoading,  double totalSurplus,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentState() when $default != null:
return $default(_that.payments,_that.dailyPayments,_that.isLoading,_that.totalSurplus,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> payments,  List<Map<String, dynamic>> dailyPayments,  bool isLoading,  double totalSurplus,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PaymentState():
return $default(_that.payments,_that.dailyPayments,_that.isLoading,_that.totalSurplus,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> payments,  List<Map<String, dynamic>> dailyPayments,  bool isLoading,  double totalSurplus,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PaymentState() when $default != null:
return $default(_that.payments,_that.dailyPayments,_that.isLoading,_that.totalSurplus,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentState implements PaymentState {
  const _PaymentState({final  List<Map<String, dynamic>> payments = const [], final  List<Map<String, dynamic>> dailyPayments = const [], this.isLoading = false, this.totalSurplus = 0.0, this.error}): _payments = payments,_dailyPayments = dailyPayments;
  

 final  List<Map<String, dynamic>> _payments;
@override@JsonKey() List<Map<String, dynamic>> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

 final  List<Map<String, dynamic>> _dailyPayments;
@override@JsonKey() List<Map<String, dynamic>> get dailyPayments {
  if (_dailyPayments is EqualUnmodifiableListView) return _dailyPayments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyPayments);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  double totalSurplus;
@override final  String? error;

/// Create a copy of PaymentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentStateCopyWith<_PaymentState> get copyWith => __$PaymentStateCopyWithImpl<_PaymentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentState&&const DeepCollectionEquality().equals(other._payments, _payments)&&const DeepCollectionEquality().equals(other._dailyPayments, _dailyPayments)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.totalSurplus, totalSurplus) || other.totalSurplus == totalSurplus)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_payments),const DeepCollectionEquality().hash(_dailyPayments),isLoading,totalSurplus,error);

@override
String toString() {
  return 'PaymentState(payments: $payments, dailyPayments: $dailyPayments, isLoading: $isLoading, totalSurplus: $totalSurplus, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PaymentStateCopyWith<$Res> implements $PaymentStateCopyWith<$Res> {
  factory _$PaymentStateCopyWith(_PaymentState value, $Res Function(_PaymentState) _then) = __$PaymentStateCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> payments, List<Map<String, dynamic>> dailyPayments, bool isLoading, double totalSurplus, String? error
});




}
/// @nodoc
class __$PaymentStateCopyWithImpl<$Res>
    implements _$PaymentStateCopyWith<$Res> {
  __$PaymentStateCopyWithImpl(this._self, this._then);

  final _PaymentState _self;
  final $Res Function(_PaymentState) _then;

/// Create a copy of PaymentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payments = null,Object? dailyPayments = null,Object? isLoading = null,Object? totalSurplus = null,Object? error = freezed,}) {
  return _then(_PaymentState(
payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,dailyPayments: null == dailyPayments ? _self._dailyPayments : dailyPayments // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,totalSurplus: null == totalSurplus ? _self.totalSurplus : totalSurplus // ignore: cast_nullable_to_non_nullable
as double,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
