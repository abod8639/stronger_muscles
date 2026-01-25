import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
@HiveType(typeId: 5, adapterName: 'ProductModelAdapter')
class ProductModel with _$ProductModel {
  const factory ProductModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required double price,
    @HiveField(3) @JsonKey(name: 'discountPrice') double? discountPrice,
    @HiveField(4)
    @JsonKey(name: 'imageUrls')
    @Default([])
    List<String> imageUrls,
    @HiveField(5) @Default('') String description,
    @HiveField(6) @JsonKey(name: 'categoryId') String? categoryId,
    @HiveField(7) @JsonKey(name: 'stockQuantity') @Default(0) int stockQuantity,
    @HiveField(8)
    @JsonKey(name: 'averageRating')
    @Default(0.0)
    double averageRating,
    @HiveField(9) @JsonKey(name: 'reviewCount') @Default(0) int reviewCount,
    @HiveField(10) String? brand,
    @HiveField(11) @JsonKey(name: 'servingSize') String? servingSize,
    @HiveField(12)
    @JsonKey(name: 'servingsPerContainer')
    int? servingsPerContainer,
    @HiveField(13) @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @HiveField(14)
    @JsonKey(name: 'is_background_white')
    @Default(false)
    bool isBackgroundWhite,

    // Basic Info
    @HiveField(15) String? sku,
    @HiveField(16) @Default([]) List<String> tags,
    @HiveField(17) double? weight,
    @HiveField(18) @JsonKey(name: 'size') @Default([]) List<String>? size,

    // Nutrition
    @HiveField(19)
    @JsonKey(name: 'nutrition_facts')
    Map<String, dynamic>? nutritionFacts,

    // Marketing
    @HiveField(20) @Default(false) bool featured,
    @HiveField(21)
    @JsonKey(name: 'new_arrival')
    @Default(false)
    bool newArrival,
    @HiveField(22)
    @JsonKey(name: 'best_seller')
    @Default(false)
    bool bestSeller,
    @HiveField(23) @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @HiveField(24) @JsonKey(name: 'views_count') @Default(0) int viewsCount,

    // Shipping
    @HiveField(25) @JsonKey(name: 'shipping_weight') double? shippingWeight,
    @HiveField(26) Map<String, dynamic>? dimensions,

    // Additional
    @HiveField(27) @Default([]) List<String> ingredients,
    @HiveField(28)
    @JsonKey(name: 'usage_instructions')
    String? usageInstructions,
    @HiveField(29) @Default([]) List<String> warnings,
    @HiveField(30) @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    @HiveField(31) String? manufacturer,
    @HiveField(32) @JsonKey(name: 'country_of_origin') String? countryOfOrigin,

    // SEO
    @HiveField(33) @JsonKey(name: 'meta_title') String? metaTitle,
    @HiveField(34) @JsonKey(name: 'meta_description') String? metaDescription,
    @HiveField(35) String? slug,

    // Timestamps
    @HiveField(36) DateTime? createdAt,
    @HiveField(37) DateTime? updatedAt,
    @HiveField(38) @JsonKey(name: 'flavors') @Default([]) List<String>? flavors,
  }) = _ProductModel;

  const ProductModel._(); // Needed for custom getters

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountPrice!) / price * 100).roundToDouble();
  }
}
