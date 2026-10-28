/// Data Transfer Object (DTO) for Checkout API response.
class CheckoutResultModel {
  const CheckoutResultModel({
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

  factory CheckoutResultModel.fromJson(
    Map<String, dynamic> json, {
    String? paymentUrl,
  }) {
    final rawData = json['data'];
    final dynamic rawId = (rawData is Map) ? rawData['id'] : json['id'];
    final String orderId = rawId != null ? rawId.toString() : '';

    final String status = (json['status'] ??
            (rawData is Map ? rawData['status'] : null) ??
            'success')
        .toString();

    final String? message = json['message']?.toString();
    final String? resolvedUrl =
        paymentUrl ?? (rawData is Map ? rawData['payment_url'] : null)?.toString();

    return CheckoutResultModel(
      orderId: orderId,
      status: status,
      message: message,
      paymentUrl: resolvedUrl,
      rawData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'status': status,
      'message': message,
      'payment_url': paymentUrl,
      'raw_data': rawData,
    };
  }
}
