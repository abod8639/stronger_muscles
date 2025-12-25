import 'package:hive/hive.dart';

part 'order_model.g.dart';

/// Order status enum
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

/// Payment status enum
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

/// Payment method enum
enum PaymentMethod {
  card,
  cashOnDelivery,
}

@HiveType(typeId: 2)
class OrderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final DateTime orderDate;

  @HiveField(3)
  final String status; // 'pending', 'processing', 'shipped', 'delivered', 'cancelled'

  @HiveField(4)
  final String paymentStatus; // 'pending', 'paid', 'failed', 'refunded'

  @HiveField(5)
  final String paymentMethod; // 'card', 'cash_on_delivery'

  @HiveField(6)
  final String addressId;

  @HiveField(7)
  final String? shippingAddressSnapshot; // Snapshot of address at order time

  @HiveField(8)
  final double subtotal;

  @HiveField(9)
  final double shippingCost;

  @HiveField(10)
  final double discount;

  @HiveField(11)
  final double totalAmount;

  @HiveField(12)
  final String? trackingNumber;

  @HiveField(13)
  final String? notes;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  // Note: Order items are stored separately and linked by orderId
  // This maintains database normalization
  // The items field is optional and used for backwards compatibility
  @HiveField(16)
  final List<OrderItemModel>? items;

  // Legacy field for backwards compatibility
  @HiveField(17)
  final String? shippingAddress;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderDate,
    this.status = 'pending',
    this.paymentStatus = 'pending',
    this.paymentMethod = 'card',
    required this.addressId,
    this.shippingAddressSnapshot,
    required this.subtotal,
    this.shippingCost = 0,
    this.discount = 0,
    required this.totalAmount,
    this.trackingNumber,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.items,
    this.shippingAddress,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? 'card',
      addressId: json['addressId'] ?? '',
      shippingAddressSnapshot: json['shippingAddressSnapshot'],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      trackingNumber: json['trackingNumber'],
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert OrderModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'orderDate': orderDate.toIso8601String(),
        'status': status,
        'paymentStatus': paymentStatus,
        'paymentMethod': paymentMethod,
        'addressId': addressId,
        'shippingAddressSnapshot': shippingAddressSnapshot,
        'subtotal': subtotal,
        'shippingCost': shippingCost,
        'discount': discount,
        'totalAmount': totalAmount,
        'trackingNumber': trackingNumber,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Create a copy with updated fields
  OrderModel copyWith({
    String? id,
    String? userId,
    DateTime? orderDate,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? addressId,
    String? shippingAddressSnapshot,
    double? subtotal,
    double? shippingCost,
    double? discount,
    double? totalAmount,
    String? trackingNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      addressId: addressId ?? this.addressId,
      shippingAddressSnapshot:
          shippingAddressSnapshot ?? this.shippingAddressSnapshot,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if order is paid
  bool get isPaid => paymentStatus == 'paid';

  /// Check if order can be cancelled
  bool get canBeCancelled =>
      status == 'pending' || status == 'processing';

  /// Check if order is completed
  bool get isCompleted => status == 'delivered';

  /// Get status display text
  String get statusDisplayText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

@HiveType(typeId: 3)
class OrderItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String orderId;

  @HiveField(2)
  final String productId;

  @HiveField(3)
  final String productName; // Snapshot at order time

  @HiveField(4)
  final double unitPrice; // Price at order time

  @HiveField(5)
  final int quantity;

  @HiveField(6)
  final double subtotal;

  @HiveField(7)
  final String? imageUrl; // Snapshot at order time

  @HiveField(8)
  final DateTime createdAt;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    double? subtotal,
    this.imageUrl,
    DateTime? createdAt,
  })  : subtotal = subtotal ?? (unitPrice * quantity),
        createdAt = createdAt ?? DateTime.now();

  /// Factory constructor to create OrderItemModel from JSON
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      subtotal: json['subtotal']?.toDouble(),
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Convert OrderItemModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'productId': productId,
        'productName': productName,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'subtotal': subtotal,
        'imageUrl': imageUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Create a copy with updated fields
  OrderItemModel copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? productName,
    double? unitPrice,
    int? quantity,
    double? subtotal,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
