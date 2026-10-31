import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_size_entity.dart';

part 'product_size_model.freezed.dart';
part 'product_size_model.g.dart';

final Expando<Map<String, dynamic>> _sizeMetaExpando =
    Expando<Map<String, dynamic>>();

extension ProductSizeMetaExtension on ProductSize {
  int? get servings => _sizeMetaExpando[this]?['servings'] as int?;
  set servings(int? value) {
    final meta = _sizeMetaExpando[this] ?? <String, dynamic>{};
    meta['servings'] = value;
    _sizeMetaExpando[this] = meta;
  }

  String? get weight => _sizeMetaExpando[this]?['weight'] as String?;
  set weight(String? value) {
    final meta = _sizeMetaExpando[this] ?? <String, dynamic>{};
    meta['weight'] = value;
    _sizeMetaExpando[this] = meta;
  }

  int? get stockQuantity => _sizeMetaExpando[this]?['stockQuantity'] as int?;
  set stockQuantity(int? value) {
    final meta = _sizeMetaExpando[this] ?? <String, dynamic>{};
    meta['stockQuantity'] = value;
    _sizeMetaExpando[this] = meta;
  }

  List<String>? get flavors =>
      _sizeMetaExpando[this]?['flavors'] as List<String>?;
  set flavors(List<String>? value) {
    final meta = _sizeMetaExpando[this] ?? <String, dynamic>{};
    meta['flavors'] = value;
    _sizeMetaExpando[this] = meta;
  }
}

@freezed
@HiveType(typeId: 10, adapterName: 'ProductSizeAdapter')
class ProductSize with _$ProductSize {
  const factory ProductSize({
    @HiveField(0) @JsonKey(name: 'size') required String size,
    @HiveField(1) @JsonKey(name: 'price') required double price,
    @HiveField(2) @JsonKey(name: 'discount_price') double? discountPrice,
  }) = _ProductSize;

  const ProductSize._();

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    final size = _$ProductSizeFromJson(json);
    final rawServings = json['servings'] ?? json['servings_per_container'];
    final servings = rawServings is num
        ? rawServings.toInt()
        : int.tryParse(rawServings?.toString() ?? '');
    final weight = (json['weight'] ?? json['serving_size'])?.toString();
    final rawStock =
        json['stock_quantity'] ?? json['stockQuantity'] ?? json['stock'];
    final stock = rawStock is num
        ? rawStock.toInt()
        : int.tryParse(rawStock?.toString() ?? '');
    final rawFlavors = (json['flavors'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();
    if (servings != null ||
        (weight != null && weight.isNotEmpty) ||
        stock != null ||
        (rawFlavors != null && rawFlavors.isNotEmpty)) {
      final meta = <String, dynamic>{};
      if (servings != null) meta['servings'] = servings;
      if (weight != null && weight.isNotEmpty) meta['weight'] = weight;
      if (stock != null) meta['stockQuantity'] = stock;
      if (rawFlavors != null) meta['flavors'] = rawFlavors;
      _sizeMetaExpando[size] = meta;
    }
    return size;
  }

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
        servings: servings,
        weight: weight,
        stockQuantity: stockQuantity,
        flavors: flavors,
      );

  static ProductSize fromEntity(ProductSizeEntity entity) {
    final s = ProductSize(
      size: entity.size,
      price: entity.price,
      discountPrice: entity.discountPrice,
    );
    s.servings = entity.servings;
    s.weight = entity.weight;
    s.stockQuantity = entity.stockQuantity;
    return s;
  }
}
