import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 2)
class OrderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime orderDate;

  @HiveField(2)
  final String status; // 'pending', 'processing', 'delivered', 'cancelled'

  @HiveField(3)
  final List<OrderItem> items;

  @HiveField(4)
  final double totalAmount;

  @HiveField(5)
  final String shippingAddress;

  @HiveField(6)
  final String? trackingNumber;

  OrderModel({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    this.trackingNumber,
  });
}

@HiveType(typeId: 3)
class OrderItem {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}
