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

  /// Factory with defensive fallbacks preventing null or invalid values.
  factory CheckoutItemEntity.fromCartItem(CartItemEntity item, {String locale = 'en'}) {
    final validQty = item.quantity <= 0 ? 1 : item.quantity;
    final validPrice = item.product.baseEffectivePrice.isNaN ? 0.0 : item.product.baseEffectivePrice;

    return CheckoutItemEntity(
      productId: item.product.id,
      quantity: validQty,
      selectedFlavor: item.selectedFlavor,
      selectedSize: item.selectedSize,
      unitPrice: validPrice,
      productName: item.product.getLocalizedName(locale: locale),
    );
  }

  /// Safe deserialization from JSON with default values preventing type errors.
  factory CheckoutItemEntity.fromJson(Map<String, dynamic> json) {
    return CheckoutItemEntity(
      productId: (json['product_id'] ?? json['id'] ?? '').toString(),
      quantity: (json['quantity'] is num) ? (json['quantity'] as num).toInt() : 1,
      selectedFlavor: json['selected_flavor']?.toString(),
      selectedSize: json['selected_size']?.toString(),
      unitPrice: (json['unit_price'] is num) ? (json['unit_price'] as num).toDouble() : 0.0,
      productName: (json['product_name'] ?? json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'quantity': quantity,
        if (selectedFlavor != null) 'selected_flavor': selectedFlavor,
        if (selectedSize != null) 'selected_size': selectedSize,
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

  /// Builds the serialized payload on the main thread.
  Map<String, dynamic> toPayload() => {
        'address_id': addressId,
        'payment_method': paymentMethod,
        'notes': notes,
        'items': items.map((i) => i.toMap()).toList(),
      };

  /// Offloads payload serialization to a background isolate via [compute]
  /// for larger item collections, completely avoiding UI thread freezing.
  Future<Map<String, dynamic>> toPayloadAsync() async {
    if (items.length > 5) {
      return compute(_serializePayloadIsolate, this);
    }
    return toPayload();
  }

  bool get isOnlinePayment =>
      paymentMethod == 'card' ||
      paymentMethod == 'stripe' ||
      paymentMethod == 'paymob';

  String get gateway => paymentMethod == 'stripe' ? 'stripe' : 'paymob';
}

Map<String, dynamic> _serializePayloadIsolate(CheckoutParams params) {
  return params.toPayload();
}
