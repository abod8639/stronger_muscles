// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemModelAdapter extends TypeAdapter<_$CartItemModelImpl> {
  @override
  final int typeId = 0;

  @override
  _$CartItemModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$CartItemModelImpl(
      id: fields[0] as String,
      userId: fields[1] as String,
      productId: fields[2] as String,
      productName: fields[3] as String,
      price: fields[4] as double,
      imageUrls: (fields[5] as List).cast<String>(),
      quantity: fields[6] as int,
      addedAt: fields[7] as DateTime?,
      selectedFlavor: fields[8] as String?,
      brand: fields[9] as String?,
      weight: fields[10] as double?,
      size: fields[11] as String?,
      sku: fields[12] as String?,
      categoryId: fields[13] as String?,
      flavors: (fields[14] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$CartItemModelImpl obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.productName)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.addedAt)
      ..writeByte(8)
      ..write(obj.selectedFlavor)
      ..writeByte(9)
      ..write(obj.brand)
      ..writeByte(10)
      ..write(obj.weight)
      ..writeByte(11)
      ..write(obj.size)
      ..writeByte(12)
      ..write(obj.sku)
      ..writeByte(13)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.imageUrls)
      ..writeByte(14)
      ..write(obj.flavors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      addedAt: json['added_at'] == null
          ? null
          : DateTime.parse(json['added_at'] as String),
      selectedFlavor: json['selected_flavor'] as String?,
      brand: json['brand'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      size: json['size'] as String?,
      sku: json['sku'] as String?,
      categoryId: json['category_id'] as String?,
      flavors: (json['flavors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'price': instance.price,
      'image_urls': instance.imageUrls,
      'quantity': instance.quantity,
      'added_at': instance.addedAt?.toIso8601String(),
      'selected_flavor': instance.selectedFlavor,
      'brand': instance.brand,
      'weight': instance.weight,
      'size': instance.size,
      'sku': instance.sku,
      'category_id': instance.categoryId,
      'flavors': instance.flavors,
    };
