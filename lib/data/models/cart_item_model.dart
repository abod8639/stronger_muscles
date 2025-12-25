import 'package:hive/hive.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final String id; // Unique cart item ID

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String productId;

  @HiveField(3)
  final String productName; // Cached for display

  @HiveField(4)
  final double price; // Cached for display

  @HiveField(5)
  final List<String> imageUrls; // Cached for display

  @HiveField(6)
  int quantity;

  @HiveField(7)
  final DateTime addedAt;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrls,
    this.quantity = 1,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Factory constructor to create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      quantity: json['quantity'] ?? 1,
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }

  /// Convert CartItemModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'productId': productId,
        'productName': productName,
        'price': price,
        'imageUrls': imageUrls,
        'quantity': quantity,
        'addedAt': addedAt.toIso8601String(),
      };

  /// Create a copy with updated fields
  CartItemModel copyWith({
    String? id,
    String? userId,
    String? productId,
    String? productName,
    double? price,
    List<String>? imageUrls,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  /// Get subtotal for this cart item
  double get subtotal => price * quantity;

  /// Get primary image URL
  String? get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  /// Increase quantity
  void incrementQuantity() {
    quantity++;
  }

  /// Decrease quantity (minimum 1)
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
