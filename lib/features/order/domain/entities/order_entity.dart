import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_item_entity.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';

/// Pure domain entity representing an order.
@immutable
class OrderEntity {
  final String id;
  final String userId;
  final DateTime? orderDate;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String addressId;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final double totalAmount;
  final String? trackingNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItemEntity>? items;
  final AddressEntity? shippingAddress;
  final String? phoneNumber;
  final String? userName;

  const OrderEntity({
    required this.id,
    required this.userId,
    this.orderDate,
    this.status = 'pending',
    this.paymentStatus = 'pending',
    this.paymentMethod = 'cash',
    required this.addressId,
    required this.subtotal,
    this.shippingCost = 0.0,
    this.discount = 0.0,
    required this.totalAmount,
    this.trackingNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.shippingAddress,
    this.phoneNumber,
    this.userName,
  });

  String get formattedDate {
    if (orderDate == null) return '';
    return DateFormat('d MMMM yyyy').format(orderDate!);
  }

  bool get isPaid => paymentStatus == 'paid';
  bool get canBeCancelled => status == 'pending' || status == 'processing';
  bool get isCompleted => status == 'delivered';

  OrderEntity copyWith({
    String? id,
    String? userId,
    DateTime? orderDate,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? addressId,
    double? subtotal,
    double? shippingCost,
    double? discount,
    double? totalAmount,
    String? trackingNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItemEntity>? items,
    AddressEntity? shippingAddress,
    String? phoneNumber,
    String? userName,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      addressId: addressId ?? this.addressId,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userName: userName ?? this.userName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'OrderEntity(id: $id, status: $status, totalAmount: $totalAmount)';
}
