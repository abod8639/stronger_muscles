import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Pure domain entity representing an item in the cart.
/// Follows Clean Architecture by decoupling business domain from storage and serialization.
@immutable
class CartItemEntity {
  final String id;
  final String userId;
  final ProductEntity product;
  final int quantity;
  final DateTime? addedAt;
  final String? selectedFlavor;
  final String? selectedSize;

  const CartItemEntity({
    required this.id,
    required this.userId,
    required this.product,
    this.quantity = 1,
    this.addedAt,
    this.selectedFlavor,
    this.selectedSize,
  });

  /// Subtotal for this cart item based on the selected size's effective price.
  double get subtotal =>
      product.getEffectivePriceForSize(selectedSize) * quantity;

  /// Primary image URL of the product.
  String? get primaryImageUrl => product.primaryImageUrl;

  CartItemEntity copyWith({
    String? id,
    String? userId,
    ProductEntity? product,
    int? quantity,
    DateTime? addedAt,
    String? selectedFlavor,
    String? selectedSize,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      selectedFlavor: selectedFlavor ?? this.selectedFlavor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          quantity == other.quantity &&
          selectedFlavor == other.selectedFlavor &&
          selectedSize == other.selectedSize;

  @override
  int get hashCode =>
      Object.hash(id, quantity, selectedFlavor, selectedSize);

  @override
  String toString() =>
      'CartItemEntity(id: $id, userId: $userId, product: ${product.id}, quantity: $quantity, flavor: $selectedFlavor, size: $selectedSize)';
}
