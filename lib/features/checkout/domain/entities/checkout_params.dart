/// 100% Pure Dart Checkout Entities.
///
/// Contains zero framework, Flutter UI, Dio, or Hive dependencies.
library;

class CheckoutItemEntity {
  const CheckoutItemEntity({
    required this.productId,
    required this.quantity,
    this.productName = '',
    this.unitPrice = 0.0,
    this.selectedFlavor,
    this.selectedSize,
    this.imageUrl,
  });

  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final String? selectedFlavor;
  final String? selectedSize;
  final String? imageUrl;

  double get totalPrice => unitPrice * quantity;

  CheckoutItemEntity copyWith({
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    String? selectedFlavor,
    String? selectedSize,
    String? imageUrl,
  }) {
    return CheckoutItemEntity(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      selectedFlavor: selectedFlavor ?? this.selectedFlavor,
      selectedSize: selectedSize ?? this.selectedSize,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckoutItemEntity &&
        other.productId == productId &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.selectedFlavor == selectedFlavor &&
        other.selectedSize == selectedSize &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      productId,
      productName,
      quantity,
      unitPrice,
      selectedFlavor,
      selectedSize,
      imageUrl,
    );
  }

  @override
  String toString() {
    return 'CheckoutItemEntity(productId: $productId, name: $productName, quantity: $quantity, price: $unitPrice)';
  }
}

/// Pure domain parameters object passed to process the order placement.
class CheckoutParams {
  const CheckoutParams({
    required this.addressId,
    required this.paymentMethod,
    this.notes = '',
    required this.items,
    this.customerName,
  });

  final dynamic addressId;
  final String paymentMethod;
  final String notes;
  final List<CheckoutItemEntity> items;
  final String? customerName;

  bool get isOnlinePayment =>
      paymentMethod == 'card' ||
      paymentMethod == 'stripe' ||
      paymentMethod == 'paymob';

  String get gateway => paymentMethod == 'stripe' ? 'stripe' : 'paymob';

  double get totalAmount => items.fold(
        0.0,
        (sum, item) => sum + (item.unitPrice * item.quantity),
      );

  CheckoutParams copyWith({
    dynamic addressId,
    String? paymentMethod,
    String? notes,
    List<CheckoutItemEntity>? items,
    String? customerName,
  }) {
    return CheckoutParams(
      addressId: addressId ?? this.addressId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckoutParams &&
        other.addressId == addressId &&
        other.paymentMethod == paymentMethod &&
        other.notes == notes &&
        other.customerName == customerName;
  }

  @override
  int get hashCode {
    return Object.hash(addressId, paymentMethod, notes, customerName);
  }

  @override
  String toString() {
    return 'CheckoutParams(addressId: $addressId, paymentMethod: $paymentMethod, itemsCount: ${items.length})';
  }
}
