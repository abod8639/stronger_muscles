import 'package:flutter/foundation.dart';

/// Pure domain entity representing an item inside an order.
@immutable
class OrderItemEntity {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double subtotal;
  final String? imageUrl;
  final DateTime? createdAt;
  final String? selectedFlavor;
  final String? selectedSize;

  const OrderItemEntity({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    this.imageUrl,
    this.createdAt,
    this.selectedFlavor,
    this.selectedSize,
  });

  double get price => unitPrice;

  OrderItemEntity copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? productName,
    double? unitPrice,
    int? quantity,
    double? subtotal,
    String? imageUrl,
    DateTime? createdAt,
    String? selectedFlavor,
    String? selectedSize,
  }) {
    return OrderItemEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      selectedFlavor: selectedFlavor ?? this.selectedFlavor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'OrderItemEntity(id: $id, productName: $productName, quantity: $quantity)';
}
