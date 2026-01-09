import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
@HiveType(typeId: 2, adapterName: 'OrderModelAdapter')
class OrderModel with _$OrderModel {
  const factory OrderModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'user_id') required String userId,
    @HiveField(2) @JsonKey(name: 'order_date') required DateTime orderDate,
    @HiveField(3) @Default('pending') String status,
    @HiveField(4) @JsonKey(name: 'payment_status') @Default('pending') String paymentStatus,
    @HiveField(5) @JsonKey(name: 'payment_method') @Default('card') String paymentMethod,
    @HiveField(6) @JsonKey(name: 'address_id') required String addressId,
    @HiveField(7) @JsonKey(name: 'shipping_address_snapshot') String? shippingAddressSnapshot,
    @HiveField(8) required double subtotal,
    @HiveField(9) @Default(0) double shippingCost,
    @HiveField(10) @Default(0) double discount,
    @HiveField(11) @JsonKey(name: 'total_amount') required double totalAmount,
    @HiveField(12) @JsonKey(name: 'tracking_number') String? trackingNumber,
    @HiveField(13) String? notes,
    @HiveField(14) DateTime? createdAt,
    @HiveField(15) DateTime? updatedAt,
    @HiveField(16) @JsonKey(name: 'order_items') List<OrderItemModel>? items,
    @HiveField(17) String? shippingAddress,
    @HiveField(18) String? selectedFlavor,
    @HiveField(19) String? selectedSize,
  }) = _OrderModel;

  const OrderModel._();

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  
  bool get isPaid => paymentStatus == 'paid';
  bool get canBeCancelled => status == 'pending' || status == 'processing';
  bool get isCompleted => status == 'delivered';
}

@freezed
@HiveType(typeId: 3, adapterName: 'OrderItemModelAdapter')
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    @HiveField(0) required String id, // can be empty for new items
    @HiveField(1) @JsonKey(name: 'order_id') required String orderId,
    @HiveField(2) @JsonKey(name: 'product_id') required String productId,
    @HiveField(3) @JsonKey(name: 'product_name') required String productName,
    @HiveField(4) @JsonKey(name: 'unit_price') required double unitPrice,
    @HiveField(5) required int quantity,
    @HiveField(6) required double subtotal,
    @HiveField(7) @JsonKey(name: 'image_url') String? imageUrl,
    @HiveField(8) DateTime? createdAt,
    @HiveField(9) String? selectedFlavor,
    @HiveField(10) String? selectedSize,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
}
