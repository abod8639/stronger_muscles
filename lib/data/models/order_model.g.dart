// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 2;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      orderDate: fields[2] as DateTime,
      status: fields[3] as String,
      paymentStatus: fields[4] as String,
      paymentMethod: fields[5] as String,
      addressId: fields[6] as String,
      shippingAddressSnapshot: fields[7] as String?,
      subtotal: fields[8] as double,
      shippingCost: fields[9] as double,
      discount: fields[10] as double,
      totalAmount: fields[11] as double,
      trackingNumber: fields[12] as String?,
      notes: fields[13] as String?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
      items: (fields[16] as List?)?.cast<OrderItemModel>(),
      shippingAddress: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.orderDate)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.paymentStatus)
      ..writeByte(5)
      ..write(obj.paymentMethod)
      ..writeByte(6)
      ..write(obj.addressId)
      ..writeByte(7)
      ..write(obj.shippingAddressSnapshot)
      ..writeByte(8)
      ..write(obj.subtotal)
      ..writeByte(9)
      ..write(obj.shippingCost)
      ..writeByte(10)
      ..write(obj.discount)
      ..writeByte(11)
      ..write(obj.totalAmount)
      ..writeByte(12)
      ..write(obj.trackingNumber)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.items)
      ..writeByte(17)
      ..write(obj.shippingAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderItemModelAdapter extends TypeAdapter<OrderItemModel> {
  @override
  final int typeId = 3;

  @override
  OrderItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItemModel(
      id: fields[0] as String,
      orderId: fields[1] as String,
      productId: fields[2] as String,
      productName: fields[3] as String,
      unitPrice: fields[4] as double,
      quantity: fields[5] as int,
      subtotal: fields[6] as double?,
      imageUrl: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItemModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.productName)
      ..writeByte(4)
      ..write(obj.unitPrice)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.subtotal)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
