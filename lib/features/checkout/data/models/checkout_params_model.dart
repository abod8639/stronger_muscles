import 'checkout_item_model.dart';

/// Data Transfer Object (DTO) for Checkout Parameters and Payload Serialization.
class CheckoutParamsModel {
  const CheckoutParamsModel({
    required this.addressId,
    required this.paymentMethod,
    this.notes = '',
    required this.items,
    this.customerName,
  });

  final dynamic addressId;
  final String paymentMethod;
  final String notes;
  final List<CheckoutItemModel> items;
  final String? customerName;

  factory CheckoutParamsModel.fromJson(Map<String, dynamic> json) {
    return CheckoutParamsModel(
      addressId: json['address_id'],
      paymentMethod: (json['payment_method'] ?? 'cash').toString(),
      notes: (json['notes'] ?? '').toString(),
      items: (json['items'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(CheckoutItemModel.fromJson)
              .toList() ??
          const [],
      customerName: json['customer_name'] as String?,
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'address_id': addressId,
      'payment_method': paymentMethod,
      'notes': notes,
      'items': items.map((i) => i.toJson()).toList(),
      if (customerName != null) 'customer_name': customerName,
    };
  }

  Map<String, dynamic> toJson() => toPayload();
}
