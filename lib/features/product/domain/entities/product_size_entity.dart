/// Pure domain entity representing a product size variant with its pricing.
class ProductSizeEntity {
  final String size;
  final double price;
  final double? discountPrice;
  final int? servings;
  final String? weight;
  final int? stockQuantity;
  final List<String>? flavors;

  const ProductSizeEntity({
    required this.size,
    required this.price,
    this.discountPrice,
    this.servings,
    this.weight,
    this.stockQuantity,
    this.flavors,
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
    int? servings,
    String? weight,
    int? stockQuantity,
    List<String>? flavors,
  }) {
    return ProductSizeEntity(
      size: size ?? this.size,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      servings: servings ?? this.servings,
      weight: weight ?? this.weight,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      flavors: flavors ?? this.flavors,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSizeEntity &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          price == other.price &&
          discountPrice == other.discountPrice &&
          servings == other.servings &&
          weight == other.weight &&
          stockQuantity == other.stockQuantity;

  @override
  int get hashCode =>
      size.hashCode ^
      price.hashCode ^
      discountPrice.hashCode ^
      servings.hashCode ^
      weight.hashCode ^
      stockQuantity.hashCode;

  @override
  String toString() =>
      'ProductSizeEntity(size: $size, price: $price, discountPrice: $discountPrice, servings: $servings, weight: $weight, stock: $stockQuantity)';
}
