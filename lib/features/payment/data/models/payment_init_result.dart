/// Data Transfer Object representing the raw payment initiation response from the server.
/// Pure DTO, strictly decoupled from Domain Layer Entities.
class PaymentInitResult {
  final bool success;
  final String paymentUrl;
  final String transactionId;
  final String reference;
  final String? clientSecret;

  const PaymentInitResult({
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

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'payment_url': paymentUrl,
      'transaction_id': transactionId,
      'reference': reference,
      if (clientSecret != null) 'client_secret': clientSecret,
    };
  }

  PaymentInitResult copyWith({
    bool? success,
    String? paymentUrl,
    String? transactionId,
    String? reference,
    String? clientSecret,
  }) {
    return PaymentInitResult(
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
      other is PaymentInitResult &&
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
      'PaymentInitResult(success: $success, transactionId: $transactionId, reference: $reference)';
}
