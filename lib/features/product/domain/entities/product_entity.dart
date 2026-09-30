import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/product/domain/entities/image_url_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_category_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_size_entity.dart';

/// Pure domain entity representing a product.
/// Encapsulates all domain-level product logic and business rules.
@immutable
class ProductEntity {
  final String id;
  final LocalizedStringEntity? name;
  final LocalizedStringEntity? description;
  final String? brand;
  final ProductCategoryEntity? category;
  final List<ImageUrlEntity> imageUrls;
  final bool hasVariants;
  final double price;
  final double? discountPrice;
  final int stockQuantity;
  final double averageRating;
  final int reviewCount;
  final String? servingSize;
  final int servingsPerContainer;
  final Map<String, dynamic>? nutritionFacts;
  final List<String> flavors;
  final List<ProductSizeEntity> productSizes;
  final List<String> size;
  final List<String> tags;
  final double? weight;
  final bool isActive;
  final bool isBackgroundWhite;
  final bool featured;
  final bool newArrival;
  final bool bestSeller;
  final String? sku;
  final int totalSales;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> ingredients;
  final String? manufacturer;
  final String? countryOfOrigin;
  final String? usageInstructions;
  final List<String> warnings;

  const ProductEntity({
    required this.id,
    this.name,
    this.description,
    this.brand,
    this.category,
    this.imageUrls = const [],
    this.hasVariants = false,
    this.price = 0.0,
    this.discountPrice,
    this.stockQuantity = 0,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.servingSize,
    this.servingsPerContainer = 0,
    this.nutritionFacts,
    this.flavors = const [],
    this.productSizes = const [],
    this.size = const [],
    this.tags = const [],
    this.weight,
    this.isActive = true,
    this.isBackgroundWhite = false,
    this.featured = false,
    this.newArrival = false,
    this.bestSeller = false,
    this.sku,
    this.totalSales = 0,
    this.createdAt,
    this.updatedAt,
    this.ingredients = const [],
    this.manufacturer,
    this.countryOfOrigin,
    this.usageInstructions,
    this.warnings = const [],
  });

  /// Get the product name in the specified locale
  String getLocalizedName({String locale = 'en'}) {
    return name?.getValue(locale: locale) ?? '';
  }

  /// Get the product description in the specified locale
  String getLocalizedDescription({String locale = 'en'}) {
    return description?.getValue(locale: locale) ?? '';
  }

  /// Get the primary image URL
  String? get primaryImageUrl =>
      imageUrls.isNotEmpty ? imageUrls.first.medium : null;

  /// Get the primary thumbnail URL
  String? get primaryThumbnailUrl =>
      imageUrls.isNotEmpty ? imageUrls.first.thumbnail : null;

  /// Check if product has a discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  /// Calculate discount percentage
  double get discountPercentage {
    if (!hasDiscount || price <= 0) return 0;
    return ((price - discountPrice!) / price * 100).roundToDouble();
  }

  /// Get specific price for a size, fallback to base price
  double getPriceForSize(String? sizeName) {
    if (sizeName == null || productSizes.isEmpty) return basePrice;
    for (final s in productSizes) {
      if (s.size == sizeName) return s.price;
    }
    return basePrice;
  }

  /// Get specific effective price for a size, fallback to base effective price
  double getEffectivePriceForSize(String? sizeName) {
    if (sizeName == null || productSizes.isEmpty) return baseEffectivePrice;
    for (final s in productSizes) {
      if (s.size == sizeName) return s.effectivePrice;
    }
    return baseEffectivePrice;
  }

  /// Check if a specific size has a discount
  bool hasDiscountForSize(String? sizeName) {
    if (sizeName == null || productSizes.isEmpty) return hasDiscount;
    for (final s in productSizes) {
      if (s.size == sizeName) return s.hasDiscount;
    }
    return hasDiscount;
  }

  /// Formatted price strings
  String get formattedPrice => basePrice.toStringAsFixed(2);
  String get formattedEffectivePrice => baseEffectivePrice.toStringAsFixed(2);

  /// Get category ID
  String? get categoryId => category?.id;

  /// Check if product is in stock
  bool get isInStock => stockQuantity > 0;

  /// Get default size (first size in the list)
  String? get defaultSize => size.isNotEmpty ? size.first : null;

  /// Get first product size
  ProductSizeEntity? get firstProductSize =>
      productSizes.isNotEmpty ? productSizes.first : null;

  /// Get the base price, fallback to first size if 0
  double get basePrice {
    if (price > 0) return price;
    if (productSizes.isNotEmpty) return productSizes.first.price;
    return 0;
  }

  /// Get the base effective price, fallback to first size if 0
  double get baseEffectivePrice {
    if (hasDiscount) return discountPrice!;
    if (price > 0) return price;
    if (productSizes.isNotEmpty) return productSizes.first.effectivePrice;
    return 0;
  }

  /// Check if the base price has a discount
  bool get baseHasDiscount => baseEffectivePrice < basePrice && basePrice > 0;

  ProductEntity copyWith({
    String? id,
    LocalizedStringEntity? name,
    LocalizedStringEntity? description,
    String? brand,
    ProductCategoryEntity? category,
    List<ImageUrlEntity>? imageUrls,
    bool? hasVariants,
    double? price,
    double? discountPrice,
    int? stockQuantity,
    double? averageRating,
    int? reviewCount,
    String? servingSize,
    int? servingsPerContainer,
    Map<String, dynamic>? nutritionFacts,
    List<String>? flavors,
    List<ProductSizeEntity>? productSizes,
    List<String>? size,
    List<String>? tags,
    double? weight,
    bool? isActive,
    bool? isBackgroundWhite,
    bool? featured,
    bool? newArrival,
    bool? bestSeller,
    String? sku,
    int? totalSales,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? ingredients,
    String? manufacturer,
    String? countryOfOrigin,
    String? usageInstructions,
    List<String>? warnings,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      hasVariants: hasVariants ?? this.hasVariants,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      servingSize: servingSize ?? this.servingSize,
      servingsPerContainer:
          servingsPerContainer ?? this.servingsPerContainer,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      flavors: flavors ?? this.flavors,
      productSizes: productSizes ?? this.productSizes,
      size: size ?? this.size,
      tags: tags ?? this.tags,
      weight: weight ?? this.weight,
      isActive: isActive ?? this.isActive,
      isBackgroundWhite: isBackgroundWhite ?? this.isBackgroundWhite,
      featured: featured ?? this.featured,
      newArrival: newArrival ?? this.newArrival,
      bestSeller: bestSeller ?? this.bestSeller,
      sku: sku ?? this.sku,
      totalSales: totalSales ?? this.totalSales,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ingredients: ingredients ?? this.ingredients,
      manufacturer: manufacturer ?? this.manufacturer,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      usageInstructions: usageInstructions ?? this.usageInstructions,
      warnings: warnings ?? this.warnings,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductEntity(id: $id, name: $name, price: $price)';
}
