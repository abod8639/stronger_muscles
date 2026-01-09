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
      product: fields[2] as ProductModel,
      quantity: fields[3] as int,
      addedAt: fields[4] as DateTime?,
      selectedFlavor: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, _$CartItemModelImpl obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.product)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.addedAt)
      ..writeByte(5)
      ..write(obj.selectedFlavor);
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
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      addedAt: json['added_at'] == null
          ? null
          : DateTime.parse(json['added_at'] as String),
      selectedFlavor: json['selected_flavor'] as String?,
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'product': instance.product,
      'quantity': instance.quantity,
      'added_at': instance.addedAt?.toIso8601String(),
      'selected_flavor': instance.selectedFlavor,
    };
