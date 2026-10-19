import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';

/// Pure domain entity representing an item included in checkout.
@immutable
class CheckoutItemEntity {
  final String productId;
  final int quantity;
  final String? selectedFlavor;
  final String? selectedSize;
  final double unitPrice;
  final String productName;

  const CheckoutItemEntity({
    required this.productId,
    required this.quantity,
    this.selectedFlavor,
    this.selectedSize,
    this.unitPrice = 0.0,
    this.productName = '',
  });

  factory CheckoutItemEntity.fromCartItem(CartItemEntity item, {String locale = 'en'}) {
    return CheckoutItemEntity(
      productId: item.product.id,
      quantity: item.quantity,
      selectedFlavor: item.selectedFlavor,
      selectedSize: item.selectedSize,
      unitPrice: item.product.baseEffectivePrice,
      productName: item.product.getLocalizedName(locale: locale),
    );
  }

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'quantity': quantity,
        'selected_flavor': selectedFlavor,
        'selected_size': selectedSize,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckoutItemEntity &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          quantity == other.quantity &&
          selectedFlavor == other.selectedFlavor &&
          selectedSize == other.selectedSize;

  @override
  int get hashCode =>
      Object.hash(productId, quantity, selectedFlavor, selectedSize);
}

/// Pure domain parameters object passed to process the order placement.
@immutable
class CheckoutParams {
  final dynamic addressId;
  final String paymentMethod;
  final String notes;
  final List<CheckoutItemEntity> items;
  final String? customerName;

  const CheckoutParams({
    required this.addressId,
    required this.paymentMethod,
    this.notes = '',
    required this.items,
    this.customerName,
  });

  Map<String, dynamic> toPayload() => {
        'address_id': addressId,
        'payment_method': paymentMethod,
        'notes': notes,
        'items': items.map((i) => i.toMap()).toList(),
      };

  bool get isOnlinePayment =>
      paymentMethod == 'card' ||
      paymentMethod == 'stripe' ||
      paymentMethod == 'paymob';

  String get gateway => paymentMethod == 'stripe' ? 'stripe' : 'paymob';
}
