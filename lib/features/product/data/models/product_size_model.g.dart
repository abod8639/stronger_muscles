// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_size_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductSizeAdapter extends TypeAdapter<ProductSize> {
  @override
  final int typeId = 10;

  @override
  ProductSize read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductSize(
      size: fields[0] as String,
      price: fields[1] as double,
      discountPrice: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductSize obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.size)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.discountPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductSizeImpl _$$ProductSizeImplFromJson(Map<String, dynamic> json) =>
    _$ProductSizeImpl(
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ProductSizeImplToJson(_$ProductSizeImpl instance) =>
    <String, dynamic>{
      'size': instance.size,
      'price': instance.price,
      'discount_price': instance.discountPrice,
    };
