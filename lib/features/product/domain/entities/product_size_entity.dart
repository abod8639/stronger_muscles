import 'package:flutter/foundation.dart';

/// Pure domain entity representing a product size variant with its pricing.
@immutable
class ProductSizeEntity {
  final String size;
  final double price;
  final double? discountPrice;

  const ProductSizeEntity({
    required this.size,
    required this.price,
    this.discountPrice,
  });

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountPrice!) / price * 100).roundToDouble();
  }

  ProductSizeEntity copyWith({
    String? size,
    double? price,
    double? discountPrice,
  }) {
    return ProductSizeEntity(
      size: size ?? this.size,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSizeEntity &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          price == other.price &&
          discountPrice == other.discountPrice;

  @override
  int get hashCode => size.hashCode ^ price.hashCode ^ discountPrice.hashCode;

  @override
  String toString() =>
      'ProductSizeEntity(size: $size, price: $price, discountPrice: $discountPrice)';
}
