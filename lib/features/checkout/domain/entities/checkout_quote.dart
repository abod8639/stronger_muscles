/// 100% Pure Dart Checkout Quote Entity.
///
/// The server's price for the current cart (products subtotal, delivery fee,
/// tax and grand total), computed with the same rules used when the order is
/// placed so the customer sees exactly what they will be charged.
class CheckoutQuote {
  const CheckoutQuote({
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

  bool get hasFreeDelivery => shippingCost == 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckoutQuote &&
        other.subtotal == subtotal &&
        other.shippingCost == shippingCost &&
        other.taxAmount == taxAmount &&
        other.discount == discount &&
        other.totalAmount == totalAmount &&
        other.taxRate == taxRate &&
        other.freeDeliveryThreshold == freeDeliveryThreshold &&
        other.currency == currency &&
        other.isAcceptingOrders == isAcceptingOrders;
  }

  @override
  int get hashCode => Object.hash(
        subtotal,
        shippingCost,
        taxAmount,
        discount,
        totalAmount,
        taxRate,
        freeDeliveryThreshold,
        currency,
        isAcceptingOrders,
      );

  @override
  String toString() {
    return 'CheckoutQuote(subtotal: $subtotal, shippingCost: $shippingCost, taxAmount: $taxAmount, totalAmount: $totalAmount)';
  }
}
