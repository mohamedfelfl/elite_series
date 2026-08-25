import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    int? id,
    required int studentId,

    /// Month of the payment (1-12)
    required int month,

    /// Year of the payment
    required int year,

    /// Total amount due for this month
    required double totalAmount,

    /// Amount actually paid (can exceed totalAmount — surplus carries forward)
    required double paidAmount,

    /// Date when the payment was made
    DateTime? paidDate,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

/// Extension to compute payment status fields.
extension PaymentStatus on Payment {
  /// The remaining amount due this month.
  /// Negative means overpayment (surplus carries forward).
  double get remainingAmount => totalAmount - paidAmount;

  /// The surplus that carries forward to the next month.
  /// Returns 0 if no overpayment.
  double get surplusAmount =>
      paidAmount > totalAmount ? paidAmount - totalAmount : 0;

  /// Whether this payment is fully settled.
  bool get isPaid => paidAmount >= totalAmount;

  /// Whether the student overpaid (has carry-forward credit).
  bool get hasOverpayment => paidAmount > totalAmount;
}
