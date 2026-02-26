// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 5;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as LocalizedString?,
      description: fields[2] as LocalizedString?,
      brand: fields[3] as String?,
      category: fields[4] as ProductCategory?,
      imageUrls: (fields[5] as List).cast<ImageUrl>(),
      hasVariants: fields[6] as bool,
      price: fields[7] as double,
      discountPrice: fields[8] as double?,
      stockQuantity: fields[9] as int,
      averageRating: fields[10] as double,
      reviewCount: fields[11] as int,
      servingSize: fields[12] as String?,
      servingsPerContainer: fields[13] as int,
      nutritionFacts: (fields[14] as Map?)?.cast<String, dynamic>(),
      flavors: (fields[15] as List).cast<String>(),
      productSizes: (fields[16] as List).cast<ProductSize>(),
      size: (fields[17] as List).cast<String>(),
      tags: (fields[18] as List).cast<String>(),
      weight: fields[19] as double?,
      isActive: fields[20] as bool,
      isBackgroundWhite: fields[21] as bool,
      featured: fields[22] as bool,
      newArrival: fields[23] as bool,
      bestSeller: fields[24] as bool,
      sku: fields[25] as String?,
      totalSales: fields[26] as int,
      createdAt: fields[27] as DateTime?,
      updatedAt: fields[28] as DateTime?,
      ingredients: (fields[29] as List).cast<String>(),
      manufacturer: fields[30] as String?,
      countryOfOrigin: fields[31] as String?,
      usageInstructions: fields[32] as String?,
      warnings: (fields[33] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.imageUrls)
      ..writeByte(6)
      ..write(obj.hasVariants)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.discountPrice)
      ..writeByte(9)
      ..write(obj.stockQuantity)
      ..writeByte(10)
      ..write(obj.averageRating)
      ..writeByte(11)
      ..write(obj.reviewCount)
      ..writeByte(12)
      ..write(obj.servingSize)
      ..writeByte(13)
      ..write(obj.servingsPerContainer)
      ..writeByte(14)
      ..write(obj.nutritionFacts)
      ..writeByte(15)
      ..write(obj.flavors)
      ..writeByte(16)
      ..write(obj.productSizes)
      ..writeByte(17)
      ..write(obj.size)
      ..writeByte(18)
      ..write(obj.tags)
      ..writeByte(19)
      ..write(obj.weight)
      ..writeByte(20)
      ..write(obj.isActive)
      ..writeByte(21)
      ..write(obj.isBackgroundWhite)
      ..writeByte(22)
      ..write(obj.featured)
      ..writeByte(23)
      ..write(obj.newArrival)
      ..writeByte(24)
      ..write(obj.bestSeller)
      ..writeByte(25)
      ..write(obj.sku)
      ..writeByte(26)
      ..write(obj.totalSales)
      ..writeByte(27)
      ..write(obj.createdAt)
      ..writeByte(28)
      ..write(obj.updatedAt)
      ..writeByte(29)
      ..write(obj.ingredients)
      ..writeByte(30)
      ..write(obj.manufacturer)
      ..writeByte(31)
      ..write(obj.countryOfOrigin)
      ..writeByte(32)
      ..write(obj.usageInstructions)
      ..writeByte(33)
      ..write(obj.warnings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductModelImpl(
  id: json['id'] as String,
  name: json['name'] == null
      ? null
      : LocalizedString.fromJson(json['name'] as Map<String, dynamic>),
  description: json['description'] == null
      ? null
      : LocalizedString.fromJson(json['description'] as Map<String, dynamic>),
  brand: json['brand'] as String?,
  category: json['category'] == null
      ? null
      : ProductCategory.fromJson(json['category'] as Map<String, dynamic>),
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => ImageUrl.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  hasVariants: json['has_variants'] as bool? ?? false,
  price: (json['price'] as num?)?.toDouble() ?? 0,
  discountPrice: (json['discount_price'] as num?)?.toDouble(),
  stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
  averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
  reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
  servingSize: json['serving_size'] as String?,
  servingsPerContainer: (json['servings_per_container'] as num?)?.toInt() ?? 0,
  nutritionFacts: json['nutrition_facts'] as Map<String, dynamic>?,
  flavors:
      (json['flavors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  productSizes:
      (json['product_sizes'] as List<dynamic>?)
          ?.map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  size:
      (json['size'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  weight: (json['weight'] as num?)?.toDouble(),
  isActive: json['is_active'] as bool? ?? true,
  isBackgroundWhite: json['is_background_white'] as bool? ?? false,
  featured: json['featured'] as bool? ?? false,
  newArrival: json['new_arrival'] as bool? ?? false,
  bestSeller: json['best_seller'] as bool? ?? false,
  sku: json['sku'] as String?,
  totalSales: (json['total_sales'] as num?)?.toInt() ?? 0,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  manufacturer: json['manufacturer'] as String?,
  countryOfOrigin: json['country_of_origin'] as String?,
  usageInstructions: json['usage_instructions'] as String?,
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'brand': instance.brand,
      'category': instance.category,
      'imageUrls': instance.imageUrls,
      'has_variants': instance.hasVariants,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'stock_quantity': instance.stockQuantity,
      'average_rating': instance.averageRating,
      'review_count': instance.reviewCount,
      'serving_size': instance.servingSize,
      'servings_per_container': instance.servingsPerContainer,
      'nutrition_facts': instance.nutritionFacts,
      'flavors': instance.flavors,
      'product_sizes': instance.productSizes,
      'size': instance.size,
      'tags': instance.tags,
      'weight': instance.weight,
      'is_active': instance.isActive,
      'is_background_white': instance.isBackgroundWhite,
      'featured': instance.featured,
      'new_arrival': instance.newArrival,
      'best_seller': instance.bestSeller,
      'sku': instance.sku,
      'total_sales': instance.totalSales,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'ingredients': instance.ingredients,
      'manufacturer': instance.manufacturer,
      'country_of_origin': instance.countryOfOrigin,
      'usage_instructions': instance.usageInstructions,
      'warnings': instance.warnings,
    };
