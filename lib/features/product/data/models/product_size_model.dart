import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_size_entity.dart';

part 'product_size_model.freezed.dart';
part 'product_size_model.g.dart';

@freezed
@HiveType(typeId: 10, adapterName: 'ProductSizeAdapter')
class ProductSize with _$ProductSize {
  const factory ProductSize({
    @HiveField(0) @JsonKey(name: 'size') required String size,
    @HiveField(1) @JsonKey(name: 'price') required double price,
    @HiveField(2) @JsonKey(name: 'discount_price') double? discountPrice,
  }) = _ProductSize;

  const ProductSize._();

  factory ProductSize.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeFromJson(json);

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountPrice!) / price * 100).roundToDouble();
  }

  ProductSizeEntity toEntity() => ProductSizeEntity(
        size: size,
        price: price,
        discountPrice: discountPrice,
      );

  static ProductSize fromEntity(ProductSizeEntity entity) => ProductSize(
        size: entity.size,
        price: entity.price,
        discountPrice: entity.discountPrice,
      );
}
