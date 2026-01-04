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
    @HiveField(5) required String description,
    @HiveField(6) @JsonKey(name: 'categoryId') required String categoryId,
    @HiveField(7) @JsonKey(name: 'stockQuantity') @Default(0) int stockQuantity,
    @HiveField(8) @JsonKey(name: 'averageRating') @Default(0.0) double averageRating,
    @HiveField(9) @JsonKey(name: 'reviewCount') @Default(0) int reviewCount,
    @HiveField(10) String? brand,
    @HiveField(11) @JsonKey(name: 'servingSize') String? servingSize,
    @HiveField(12) @JsonKey(name: 'servingsPerContainer') int? servingsPerContainer,
    @HiveField(13) @JsonKey(name: 'isActive') @Default(true) bool isActive,
    @HiveField(14) DateTime? createdAt,
    @HiveField(15) DateTime? updatedAt,
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
