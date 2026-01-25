import 'package:hive/hive.dart';

part 'wishlist_item_model.g.dart';

@HiveType(typeId: 9)
class WishlistItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String productId;

  @HiveField(3)
  final DateTime addedAt;

  // Cached product info for display
  @HiveField(4)
  final String? productName;

  @HiveField(5)
  final double? productPrice;

  @HiveField(6)
  final String? productImageUrl;

  WishlistItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    DateTime? addedAt,
    this.productName,
    this.productPrice,
    this.productImageUrl,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Factory constructor to create WishlistItemModel from JSON
  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      productId: json['productId'] ?? '',
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
      productName: json['productName'],
      productPrice: json['productPrice']?.toDouble(),
      productImageUrl: json['productImageUrl'],
    );
  }

  /// Convert WishlistItemModel to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'productId': productId,
    'addedAt': addedAt.toIso8601String(),
    'productName': productName,
    'productPrice': productPrice,
    'productImageUrl': productImageUrl,
  };

  /// Create a copy with updated fields
  WishlistItemModel copyWith({
    String? id,
    String? userId,
    String? productId,
    DateTime? addedAt,
    String? productName,
    double? productPrice,
    String? productImageUrl,
  }) {
    return WishlistItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      addedAt: addedAt ?? this.addedAt,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productImageUrl: productImageUrl ?? this.productImageUrl,
    );
  }
}
