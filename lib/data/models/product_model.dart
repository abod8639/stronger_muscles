import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/localized_string_model.dart';
import 'package:stronger_muscles/data/models/image_url_model.dart';
import 'package:stronger_muscles/data/models/product_category_model.dart';
import 'package:stronger_muscles/data/models/product_size_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
@HiveType(typeId: 5, adapterName: 'ProductModelAdapter')
class ProductModel with _$ProductModel {
  const factory ProductModel({
    @HiveField(0) required String id,
    @HiveField(1) LocalizedString? name,
    @HiveField(2) LocalizedString? description,
    @HiveField(3) String? brand,
    @HiveField(4) ProductCategory? category,
    @HiveField(5)
    @JsonKey(name: 'imageUrls')
    @Default([])
    List<ImageUrl> imageUrls,
    @HiveField(6)
    @JsonKey(name: 'has_variants')
    @Default(false)
    bool hasVariants,
    @HiveField(7) @Default(0) double price,
    @HiveField(8) @JsonKey(name: 'discount_price') double? discountPrice,
    @HiveField(9) @JsonKey(name: 'stock_quantity') @Default(0) int stockQuantity,
    @HiveField(10)
    @JsonKey(name: 'average_rating')
    @Default(0.0)
    double averageRating,
    @HiveField(11) @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @HiveField(12) @JsonKey(name: 'serving_size') String? servingSize,
    @HiveField(13)
    @JsonKey(name: 'servings_per_container')
    @Default(0)
    int servingsPerContainer,
    @HiveField(14)
    @JsonKey(name: 'nutrition_facts')
    Map<String, dynamic>? nutritionFacts,
    @HiveField(15)
    @JsonKey(name: 'flavors')
    @Default([])
    List<String> flavors,
    @HiveField(16)
    @JsonKey(name: 'product_sizes')
    @Default([])
    List<ProductSize> productSizes,
    @HiveField(17)
    @JsonKey(name: 'size')
    @Default([])
    List<String> size,
    @HiveField(18) @Default([]) List<String> tags,
    @HiveField(19) double? weight,
    @HiveField(20) @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @HiveField(21)
    @JsonKey(name: 'is_background_white')
    @Default(false)
    bool isBackgroundWhite,
    @HiveField(22) @Default(false) bool featured,
    @HiveField(23)
    @JsonKey(name: 'new_arrival')
    @Default(false)
    bool newArrival,
    @HiveField(24)
    @JsonKey(name: 'best_seller')
    @Default(false)
    bool bestSeller,
    @HiveField(25) String? sku,
    @HiveField(26) @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @HiveField(27) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(28) @JsonKey(name: 'updated_at') DateTime? updatedAt,
    
    // Additional fields for product details
    @HiveField(29) @Default([]) List<String> ingredients,
    @HiveField(30) String? manufacturer,
    @HiveField(31) @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
    @HiveField(32) @JsonKey(name: 'usage_instructions') String? usageInstructions,
    @HiveField(33) @Default([]) List<String> warnings,
  }) = _ProductModel;

  const ProductModel._(); // Needed for custom getters

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Get the product name in the specified locale
  String getLocalizedName({String locale = 'en'}) {
    return name?.getValue(locale: locale) ?? '';
  }

  /// Get the product description in the specified locale
  String getLocalizedDescription({String locale = 'en'}) {
    return description?.getValue(locale: locale) ?? '';
  }

  /// Get the primary image URL
  String? get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first.medium : null;

  /// Get the primary thumbnail URL
  String? get primaryThumbnailUrl =>
      imageUrls.isNotEmpty ? imageUrls.first.thumbnail : null;

  /// Get the effective price (discount price if available, else regular price)

  /// Check if product has a discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  /// Calculate discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountPrice!) / price * 100).roundToDouble();
  }

  /// Get specific price for a size, fallback to base price
  double getPriceForSize(String? sizeName) {
    if (sizeName == null || productSizes.isEmpty) return basePrice;
    final sizeObj = productSizes.firstWhereOrNull((s) => s.size == sizeName);
    return sizeObj?.price ?? basePrice;
  }

  /// Get specific effective price for a size, fallback to base effective price
  double getEffectivePriceForSize(String? sizeName) {
    if (sizeName == null || productSizes.isEmpty) return baseEffectivePrice;
    final sizeObj = productSizes.firstWhereOrNull((s) => s.size == sizeName);
    return sizeObj?.effectivePrice ?? baseEffectivePrice;
  }

  /// Check if a specific size has a discount
  bool hasDiscountForSize(String? sizeName) {
    if (sizeName == null || productSizes.isEmpty) return hasDiscount;
    final sizeObj = productSizes.firstWhereOrNull((s) => s.size == sizeName);
    return sizeObj?.hasDiscount ?? hasDiscount;
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
  ProductSize? get firstProductSize =>
      productSizes.isNotEmpty ? productSizes.first : null;

  /// Get the base price, fallback to first size if 0
  double get basePrice {
    if (price > 0) return price;
    if (productSizes.isNotEmpty) return productSizes.first.price;
    return 0;
  }

  /// Get the base effective price, fallback to first size if 0
  double get baseEffectivePrice {
    if (productSizes.isNotEmpty) return productSizes.first.effectivePrice;
    return 0;
  }

  /// Check if the base price has a discount
  bool get baseHasDiscount => baseEffectivePrice < basePrice && basePrice > 0;
}
