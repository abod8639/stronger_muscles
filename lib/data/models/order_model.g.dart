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
      phoneNumber: fields[18] as String?,
      userName: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.shippingAddress)
      ..writeByte(18)
      ..write(obj.phoneNumber)
      ..writeByte(19)
      ..write(obj.userName);
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
      subtotal: fields[6] as double,
      imageUrl: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
      selectedFlavor: fields[9] as String?,
      selectedSize: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItemModel obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.selectedFlavor)
      ..writeByte(10)
      ..write(obj.selectedSize);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      orderDate: DateTime.parse(json['order_date'] as String),
      status: json['status'] as String? ?? 'pending',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      paymentMethod: json['payment_method'] as String? ?? 'card',
      addressId: json['address_id'] as String,
      shippingAddressSnapshot: json['shipping_address_snapshot'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      trackingNumber: json['tracking_number'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      items: (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: json['shipping_address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      userName: json['user_name'] as String?,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'order_date': instance.orderDate.toIso8601String(),
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'address_id': instance.addressId,
      'shipping_address_snapshot': instance.shippingAddressSnapshot,
      'subtotal': instance.subtotal,
      'shippingCost': instance.shippingCost,
      'discount': instance.discount,
      'total_amount': instance.totalAmount,
      'tracking_number': instance.trackingNumber,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'order_items': instance.items,
      'shipping_address': instance.shippingAddress,
      'phone_number': instance.phoneNumber,
      'user_name': instance.userName,
    };

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      selectedFlavor: json['selectedFlavor'] as String?,
      selectedSize: json['selectedSize'] as String?,
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
  _$OrderItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.orderId,
  'product_id': instance.productId,
  'product_name': instance.productName,
  'unit_price': instance.unitPrice,
  'quantity': instance.quantity,
  'subtotal': instance.subtotal,
  'image_url': instance.imageUrl,
  'created_at': instance.createdAt?.toIso8601String(),
  'selectedFlavor': instance.selectedFlavor,
  'selectedSize': instance.selectedSize,
};
