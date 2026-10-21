import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';

/// Domain entity representing the outcome of an order placement and payment setup.
@immutable
class CheckoutResultEntity {
  final String orderId;
  final String status;
  final String? message;
  final String? paymentUrl;
  final PaymentResultEntity? paymentResult;
  final Map<String, dynamic> rawData;

  const CheckoutResultEntity({
    required this.orderId,
    this.status = 'success',
    this.message,
    this.paymentUrl,
    this.paymentResult,
    this.rawData = const {},
  });

  /// Factory constructor providing defensive parsing with safe fallback defaults.
  factory CheckoutResultEntity.fromJson(
    Map<String, dynamic> json, {
    PaymentResultEntity? paymentResult,
  }) {
    final rawData = json['data'];
    final dynamic rawId = (rawData is Map) ? rawData['id'] : json['id'];
    final String orderId = rawId != null ? rawId.toString() : '';

    final String status = (json['status'] ??
            (rawData is Map ? rawData['status'] : null) ??
            'success')
        .toString();

    final String? message = json['message']?.toString();

    return CheckoutResultEntity(
      orderId: orderId,
      status: status,
      message: message,
      paymentUrl: paymentResult?.paymentUrl,
      paymentResult: paymentResult,
      rawData: json,
    );
  }

  /// Offloads heavy or deeply nested JSON analysis to a background isolate via [compute].
  static Future<CheckoutResultEntity> fromJsonAsync(
    Map<String, dynamic> json, {
    PaymentResultEntity? paymentResult,
  }) {
    return compute(
      _parseCheckoutResultIsolate,
      _CheckoutResultIsolateParams(json, paymentResult),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckoutResultEntity &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          status == other.status &&
          paymentUrl == other.paymentUrl;

  @override
  int get hashCode => Object.hash(orderId, status, paymentUrl);
}

class _CheckoutResultIsolateParams {
  final Map<String, dynamic> json;
  final PaymentResultEntity? paymentResult;

  const _CheckoutResultIsolateParams(this.json, this.paymentResult);
}

CheckoutResultEntity _parseCheckoutResultIsolate(
    _CheckoutResultIsolateParams params) {
  return CheckoutResultEntity.fromJson(
    params.json,
    paymentResult: params.paymentResult,
  );
}
