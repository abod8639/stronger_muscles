import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_item_entity.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';

/// Extension mapper to convert [OrderModel] DTO to domain [OrderEntity].
extension OrderModelMapper on OrderModel {
  OrderEntity toEntity() => OrderEntity(
        id: id,
        userId: userId,
        orderDate: orderDate,
        status: status,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        addressId: addressId,
        subtotal: subtotal,
        shippingCost: shippingCost,
        discount: discount,
        totalAmount: totalAmount,
        trackingNumber: trackingNumber,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
        items: items?.map((i) => i.toEntity()).toList(),
        shippingAddress: shippingAddress?.toEntity(),
        phoneNumber: phoneNumber,
        userName: userName,
      );
}

/// Extension mapper to convert domain [OrderEntity] to data [OrderModel] DTO.
extension OrderEntityMapper on OrderEntity {
  OrderModel toModel() => OrderModel(
        id: id,
        userId: userId,
        orderDate: orderDate,
        status: status,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        addressId: addressId,
        subtotal: subtotal,
        shippingCost: shippingCost,
        discount: discount,
        totalAmount: totalAmount,
        trackingNumber: trackingNumber,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
        items: items?.map((i) => i.toModel()).toList(),
        shippingAddress: shippingAddress != null
            ? AddressModel.fromEntity(shippingAddress!)
            : null,
        phoneNumber: phoneNumber,
        userName: userName,
      );
}

/// Extension mapper to convert [OrderItemModel] DTO to domain [OrderItemEntity].
extension OrderItemModelMapper on OrderItemModel {
  OrderItemEntity toEntity() => OrderItemEntity(
        id: id,
        orderId: orderId,
        productId: productId,
        productName: productName,
        unitPrice: unitPrice,
        quantity: quantity,
        subtotal: subtotal,
        imageUrl: imageUrl,
        createdAt: createdAt,
        selectedFlavor: selectedFlavor,
        selectedSize: selectedSize,
      );
}

/// Extension mapper to convert domain [OrderItemEntity] to data [OrderItemModel] DTO.
extension OrderItemEntityMapper on OrderItemEntity {
  OrderItemModel toModel() => OrderItemModel(
        id: id,
        orderId: orderId,
        productId: productId,
        productName: productName,
        unitPrice: unitPrice,
        quantity: quantity,
        subtotal: subtotal,
        imageUrl: imageUrl,
        createdAt: createdAt,
        selectedFlavor: selectedFlavor,
        selectedSize: selectedSize,
      );
}
