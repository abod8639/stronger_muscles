import 'package:flutter/foundation.dart';

/// Pure domain entity representing the result of a payment initiation.
@immutable
class PaymentResultEntity {
  final bool success;
  final String paymentUrl;
  final String transactionId;
  final String reference;
  final String? clientSecret;

  const PaymentResultEntity({
    required this.success,
    required this.paymentUrl,
    required this.transactionId,
    required this.reference,
    this.clientSecret,
  });

  bool get hasPaymentUrl => paymentUrl.isNotEmpty;

  PaymentResultEntity copyWith({
    bool? success,
    String? paymentUrl,
    String? transactionId,
    String? reference,
    String? clientSecret,
  }) {
    return PaymentResultEntity(
      success: success ?? this.success,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      transactionId: transactionId ?? this.transactionId,
      reference: reference ?? this.reference,
      clientSecret: clientSecret ?? this.clientSecret,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentResultEntity &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          paymentUrl == other.paymentUrl &&
          transactionId == other.transactionId &&
          reference == other.reference &&
          clientSecret == other.clientSecret;

  @override
  int get hashCode => Object.hash(
        success,
        paymentUrl,
        transactionId,
        reference,
        clientSecret,
      );

  @override
  String toString() =>
      'PaymentResultEntity(success: $success, transactionId: $transactionId, reference: $reference)';
}
