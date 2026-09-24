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
}
