/// Data Transfer Object (DTO) for the `POST /customer/orders/quote` response.
class CheckoutQuoteModel {
  const CheckoutQuoteModel({
    required this.subtotal,
    required this.shippingCost,
    required this.taxAmount,
    required this.totalAmount,
    this.discount = 0.0,
    this.taxRate = 0.0,
    this.freeDeliveryThreshold = 0.0,
    this.currency = 'EGP',
    this.isAcceptingOrders = true,
  });

  final double subtotal;
  final double shippingCost;
  final double taxAmount;
  final double discount;
  final double totalAmount;
  final double taxRate;
  final double freeDeliveryThreshold;
  final String currency;
  final bool isAcceptingOrders;

  /// Accepts either the full response (`{status, data: {...}}`) or the `data` map.
  factory CheckoutQuoteModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    double parse(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0.0;
    }

    return CheckoutQuoteModel(
      subtotal: parse(data['subtotal']),
      shippingCost: parse(data['shipping_cost']),
      taxAmount: parse(data['tax_amount']),
      discount: parse(data['discount']),
      totalAmount: parse(data['total_amount']),
      taxRate: parse(data['tax_rate']),
      freeDeliveryThreshold: parse(data['free_delivery_threshold']),
      currency: (data['currency'] ?? 'EGP').toString(),
      isAcceptingOrders: data['is_accepting_orders'] != false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'tax_amount': taxAmount,
      'discount': discount,
      'total_amount': totalAmount,
      'tax_rate': taxRate,
      'free_delivery_threshold': freeDeliveryThreshold,
      'currency': currency,
      'is_accepting_orders': isAcceptingOrders,
    };
  }
}
