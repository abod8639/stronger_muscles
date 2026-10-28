/// 100% Pure Dart Checkout Result Entity.
///
/// Contains zero framework, Flutter UI, Dio, or Hive dependencies.
class CheckoutResultEntity {
  const CheckoutResultEntity({
    required this.orderId,
    this.status = 'success',
    this.message,
    this.paymentUrl,
    this.rawData = const {},
  });

  final String orderId;
  final String status;
  final String? message;
  final String? paymentUrl;
  final Map<String, dynamic> rawData;

  bool get isSuccessful => status == 'success' || status == 'ok';

  CheckoutResultEntity copyWith({
    String? orderId,
    String? status,
    String? message,
    String? paymentUrl,
    Map<String, dynamic>? rawData,
  }) {
    return CheckoutResultEntity(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      message: message ?? this.message,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      rawData: rawData ?? this.rawData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckoutResultEntity &&
        other.orderId == orderId &&
        other.status == status &&
        other.paymentUrl == paymentUrl;
  }

  @override
  int get hashCode => Object.hash(orderId, status, paymentUrl);

  @override
  String toString() {
    return 'CheckoutResultEntity(orderId: $orderId, status: $status, paymentUrl: $paymentUrl)';
  }
}
