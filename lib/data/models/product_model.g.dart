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
      categoryId: fields[6] as String,
      stockQuantity: fields[7] as int,
      averageRating: fields[8] as double,
      reviewCount: fields[9] as int,
      brand: fields[10] as String?,
      servingSize: fields[11] as String?,
      servingsPerContainer: fields[12] as int?,
      isActive: fields[13] as bool,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(16)
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
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
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
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      brand: json['brand'] as String?,
      servingSize: json['servingSize'] as String?,
      servingsPerContainer: (json['servingsPerContainer'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
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
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
