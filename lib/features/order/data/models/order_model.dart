import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_item_entity.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
@HiveType(typeId: 2, adapterName: 'OrderModelAdapter')
class OrderModel with _$OrderModel {
  @JsonSerializable(explicitToJson: true)
  const factory OrderModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'user_id') required String userId,
    @HiveField(2) @JsonKey(name: 'order_date') DateTime? orderDate,
    @HiveField(3) @Default('pending') String status,
    @HiveField(4)
    @JsonKey(name: 'payment_status')
    @Default('pending')
    String paymentStatus,
    @HiveField(5)
    @JsonKey(name: 'payment_method')
    @Default('cash')
    String paymentMethod,
    @HiveField(6) @JsonKey(name: 'address_id') required String addressId,
    @HiveField(8) required double subtotal,
    @HiveField(9)
    @JsonKey(name: 'shippingCost')
    @Default(0)
    double shippingCost,
    @HiveField(10) @Default(0) double discount,
    @HiveField(11) @JsonKey(name: 'total_amount') required double totalAmount,
    @HiveField(12) @JsonKey(name: 'tracking_number') String? trackingNumber,
    @HiveField(13) String? notes,
    @HiveField(14) DateTime? createdAt,
    @HiveField(15) DateTime? updatedAt,
    @HiveField(16) @JsonKey(name: 'order_items') List<OrderItemModel>? items,
    @HiveField(17)
    @JsonKey(name: 'shipping_address')
    AddressModel? shippingAddress,
    @HiveField(18) @JsonKey(name: 'phone_number') String? phoneNumber,
    @HiveField(19) @JsonKey(name: 'user_name') String? userName,
  }) = _OrderModel;

  const OrderModel._();

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  String get formattedDate {
    if (orderDate == null) return '';
    return DateFormat('d MMMM yyyy').format(orderDate!);
  }

  bool get isPaid => paymentStatus == 'paid';
  bool get canBeCancelled => status == 'pending' || status == 'processing';
  bool get isCompleted => status == 'delivered';

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

  static OrderModel fromEntity(OrderEntity entity) => OrderModel(
        id: entity.id,
        userId: entity.userId,
        orderDate: entity.orderDate,
        status: entity.status,
        paymentStatus: entity.paymentStatus,
        paymentMethod: entity.paymentMethod,
        addressId: entity.addressId,
        subtotal: entity.subtotal,
        shippingCost: entity.shippingCost,
        discount: entity.discount,
        totalAmount: entity.totalAmount,
        trackingNumber: entity.trackingNumber,
        notes: entity.notes,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        items: entity.items?.map((i) => OrderItemModel.fromEntity(i)).toList(),
        shippingAddress: entity.shippingAddress != null
            ? AddressModel.fromEntity(entity.shippingAddress!)
            : null,
        phoneNumber: entity.phoneNumber,
        userName: entity.userName,
      );
}

@freezed
@HiveType(typeId: 3, adapterName: 'OrderItemModelAdapter')
class OrderItemModel with _$OrderItemModel {
  @JsonSerializable(explicitToJson: true)
  const factory OrderItemModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'order_id') required String orderId,
    @HiveField(2) @JsonKey(name: 'product_id') required String productId,
    @HiveField(3) @JsonKey(name: 'product_name') required String productName,
    @HiveField(4) @JsonKey(name: 'unit_price') required double unitPrice,
    @HiveField(5) required int quantity,
    @HiveField(6) required double subtotal,
    @HiveField(7) @JsonKey(name: 'image_url') String? imageUrl,
    @HiveField(8) DateTime? createdAt,
    @HiveField(9)
    @JsonKey(name: 'selected_flavor', includeIfNull: false)
    String? selectedFlavor,
    @HiveField(10)
    @JsonKey(name: 'selected_size', includeIfNull: false)
    String? selectedSize,
  }) = _OrderItemModel;

  const OrderItemModel._(); // Added private constructor for freezed

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  double get price => unitPrice;

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

  static OrderItemModel fromEntity(OrderItemEntity entity) => OrderItemModel(
        id: entity.id,
        orderId: entity.orderId,
        productId: entity.productId,
        productName: entity.productName,
        unitPrice: entity.unitPrice,
        quantity: entity.quantity,
        subtotal: entity.subtotal,
        imageUrl: entity.imageUrl,
        createdAt: entity.createdAt,
        selectedFlavor: entity.selectedFlavor,
        selectedSize: entity.selectedSize,
      );
}
