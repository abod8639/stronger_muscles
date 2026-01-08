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
      name: fields[1] as String,
      price: fields[2] as double,
      discountPrice: fields[3] as double?,
      imageUrls: (fields[4] as List).cast<String>(),
      description: fields[5] as String,
      categoryId: fields[6] as String?,
      stockQuantity: fields[7] as int,
      averageRating: fields[8] as double,
      reviewCount: fields[9] as int,
      brand: fields[10] as String?,
      servingSize: fields[11] as String?,
      servingsPerContainer: fields[12] as int?,
      isActive: fields[13] as bool,
      sku: fields[14] as String?,
      tags: (fields[15] as List).cast<String>(),
      weight: fields[16] as double?,
      size: fields[17] as String?,
      nutritionFacts: (fields[18] as Map?)?.cast<String, dynamic>(),
      featured: fields[19] as bool,
      newArrival: fields[20] as bool,
      bestSeller: fields[21] as bool,
      totalSales: fields[22] as int,
      viewsCount: fields[23] as int,
      shippingWeight: fields[24] as double?,
      dimensions: (fields[25] as Map?)?.cast<String, dynamic>(),
      ingredients: (fields[26] as List).cast<String>(),
      usageInstructions: fields[27] as String?,
      warnings: (fields[28] as List).cast<String>(),
      expiryDate: fields[29] as DateTime?,
      manufacturer: fields[30] as String?,
      countryOfOrigin: fields[31] as String?,
      metaTitle: fields[32] as String?,
      metaDescription: fields[33] as String?,
      slug: fields[34] as String?,
      createdAt: fields[35] as DateTime?,
      updatedAt: fields[36] as DateTime?,
      flavors: (fields[37] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(38)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.discountPrice)
      ..writeByte(4)
      ..write(obj.imageUrls)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.categoryId)
      ..writeByte(7)
      ..write(obj.stockQuantity)
      ..writeByte(8)
      ..write(obj.averageRating)
      ..writeByte(9)
      ..write(obj.reviewCount)
      ..writeByte(10)
      ..write(obj.brand)
      ..writeByte(11)
      ..write(obj.servingSize)
      ..writeByte(12)
      ..write(obj.servingsPerContainer)
      ..writeByte(13)
      ..write(obj.isActive)
      ..writeByte(14)
      ..write(obj.sku)
      ..writeByte(15)
      ..write(obj.tags)
      ..writeByte(16)
      ..write(obj.weight)
      ..writeByte(17)
      ..write(obj.size)
      ..writeByte(18)
      ..write(obj.nutritionFacts)
      ..writeByte(19)
      ..write(obj.featured)
      ..writeByte(20)
      ..write(obj.newArrival)
      ..writeByte(21)
      ..write(obj.bestSeller)
      ..writeByte(22)
      ..write(obj.totalSales)
      ..writeByte(23)
      ..write(obj.viewsCount)
      ..writeByte(24)
      ..write(obj.shippingWeight)
      ..writeByte(25)
      ..write(obj.dimensions)
      ..writeByte(26)
      ..write(obj.ingredients)
      ..writeByte(27)
      ..write(obj.usageInstructions)
      ..writeByte(28)
      ..write(obj.warnings)
      ..writeByte(29)
      ..write(obj.expiryDate)
      ..writeByte(30)
      ..write(obj.manufacturer)
      ..writeByte(31)
      ..write(obj.countryOfOrigin)
      ..writeByte(32)
      ..write(obj.metaTitle)
      ..writeByte(33)
      ..write(obj.metaDescription)
      ..writeByte(34)
      ..write(obj.slug)
      ..writeByte(35)
      ..write(obj.createdAt)
      ..writeByte(36)
      ..write(obj.updatedAt)
      ..writeByte(37)
      ..write(obj.flavors);
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

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String?,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      brand: json['brand'] as String?,
      servingSize: json['servingSize'] as String?,
      servingsPerContainer: (json['servingsPerContainer'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      sku: json['sku'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      weight: (json['weight'] as num?)?.toDouble(),
      size: json['size'] as String?,
      nutritionFacts: json['nutrition_facts'] as Map<String, dynamic>?,
      featured: json['featured'] as bool? ?? false,
      newArrival: json['new_arrival'] as bool? ?? false,
      bestSeller: json['best_seller'] as bool? ?? false,
      totalSales: (json['total_sales'] as num?)?.toInt() ?? 0,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      shippingWeight: (json['shipping_weight'] as num?)?.toDouble(),
      dimensions: json['dimensions'] as Map<String, dynamic>?,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      usageInstructions: json['usage_instructions'] as String?,
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      manufacturer: json['manufacturer'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      metaTitle: json['meta_title'] as String?,
      metaDescription: json['meta_description'] as String?,
      slug: json['slug'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      flavors:
          (json['flavor'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'imageUrls': instance.imageUrls,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'stockQuantity': instance.stockQuantity,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'brand': instance.brand,
      'servingSize': instance.servingSize,
      'servingsPerContainer': instance.servingsPerContainer,
      'isActive': instance.isActive,
      'sku': instance.sku,
      'tags': instance.tags,
      'weight': instance.weight,
      'size': instance.size,
      'nutrition_facts': instance.nutritionFacts,
      'featured': instance.featured,
      'new_arrival': instance.newArrival,
      'best_seller': instance.bestSeller,
      'total_sales': instance.totalSales,
      'views_count': instance.viewsCount,
      'shipping_weight': instance.shippingWeight,
      'dimensions': instance.dimensions,
      'ingredients': instance.ingredients,
      'usage_instructions': instance.usageInstructions,
      'warnings': instance.warnings,
      'expiry_date': instance.expiryDate?.toIso8601String(),
      'manufacturer': instance.manufacturer,
      'country_of_origin': instance.countryOfOrigin,
      'meta_title': instance.metaTitle,
      'meta_description': instance.metaDescription,
      'slug': instance.slug,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'flavor': instance.flavors,
    };
