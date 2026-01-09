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
    @HiveField(4) @JsonKey(name: 'imageUrls') @Default([]) List<String> imageUrls,
    @HiveField(5) @Default('') String description,
    @HiveField(6) @JsonKey(name: 'categoryId') String? categoryId,
    @HiveField(7) @JsonKey(name: 'stockQuantity') @Default(0) int stockQuantity,
    @HiveField(8) @JsonKey(name: 'averageRating') @Default(0.0) double averageRating,
    @HiveField(9) @JsonKey(name: 'reviewCount') @Default(0) int reviewCount,
    @HiveField(10) String? brand,
    @HiveField(11) @JsonKey(name: 'servingSize') String? servingSize,
    @HiveField(12) @JsonKey(name: 'servingsPerContainer') int? servingsPerContainer,
    @HiveField(13) @JsonKey(name: 'isActive') @Default(true) bool isActive,
    
    // Basic Info
    @HiveField(14) String? sku,
    @HiveField(15) @Default([]) List<String> tags,
    @HiveField(16) double? weight,
    @HiveField(17) @JsonKey(name: 'size') @Default([]) List<String>? size,
    
    // Nutrition
    @HiveField(18) @JsonKey(name: 'nutrition_facts') Map<String, dynamic>? nutritionFacts,
    
    // Marketing
    @HiveField(19) @Default(false) bool featured,
    @HiveField(20) @JsonKey(name: 'new_arrival') @Default(false) bool newArrival,
    @HiveField(21) @JsonKey(name: 'best_seller') @Default(false) bool bestSeller,
    @HiveField(22) @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @HiveField(23) @JsonKey(name: 'views_count') @Default(0) int viewsCount,
    
    // Shipping
    @HiveField(24) @JsonKey(name: 'shipping_weight') double? shippingWeight,
    @HiveField(25) Map<String, dynamic>? dimensions,
    
    // Additional
    @HiveField(26) @Default([]) List<String> ingredients,
    @HiveField(27) @JsonKey(name: 'usage_instructions') String? usageInstructions,
    @HiveField(28) @Default([]) List<String> warnings,
    @HiveField(29) @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    @HiveField(30) String? manufacturer,
    @HiveField(31) @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
    
    // SEO
    @HiveField(32) @JsonKey(name: 'meta_title') String? metaTitle,
    @HiveField(33) @JsonKey(name: 'meta_description') String? metaDescription,
    @HiveField(34) String? slug,
    
    // Timestamps
    @HiveField(35) DateTime? createdAt,
    @HiveField(36) DateTime? updatedAt,
    @HiveField(37) @JsonKey(name: 'flavors') @Default([]) List<String>? flavors,


  }) = _ProductModel;

  const ProductModel._(); // Needed for custom getters

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  
  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountPrice!) / price * 100).roundToDouble();
  }
}
