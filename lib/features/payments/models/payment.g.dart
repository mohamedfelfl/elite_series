// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: (json['id'] as num?)?.toInt(),
  studentId: (json['studentId'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  paidAmount: (json['paidAmount'] as num).toDouble(),
  paidDate: json['paidDate'] == null
      ? null
      : DateTime.parse(json['paidDate'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'month': instance.month,
  'year': instance.year,
  'totalAmount': instance.totalAmount,
  'paidAmount': instance.paidAmount,
  'paidDate': instance.paidDate?.toIso8601String(),
};
