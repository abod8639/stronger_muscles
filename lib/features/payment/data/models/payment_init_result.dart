import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';

class PaymentInitResult {
  final bool success;
  final String paymentUrl;
  final String transactionId;
  final String reference;
  final String? clientSecret;

  PaymentInitResult({
    required this.success,
    required this.paymentUrl,
    required this.transactionId,
    required this.reference,
    this.clientSecret,
  });

  factory PaymentInitResult.fromJson(Map<String, dynamic> json) {
    return PaymentInitResult(
      success: json['success'] as bool? ?? false,
      paymentUrl: json['payment_url'] as String? ?? '',
      transactionId: (json['transaction_id'] ?? '').toString(),
      reference: (json['reference'] ?? '').toString(),
      clientSecret: json['client_secret'] as String?,
    );
  }

  PaymentResultEntity toEntity() => PaymentResultEntity(
        success: success,
        paymentUrl: paymentUrl,
        transactionId: transactionId,
        reference: reference,
        clientSecret: clientSecret,
      );

  static PaymentInitResult fromEntity(PaymentResultEntity entity) =>
      PaymentInitResult(
        success: entity.success,
        paymentUrl: entity.paymentUrl,
        transactionId: entity.transactionId,
        reference: entity.reference,
        clientSecret: entity.clientSecret,
      );
}
