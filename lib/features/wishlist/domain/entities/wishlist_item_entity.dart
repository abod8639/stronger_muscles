import 'package:flutter/foundation.dart';

/// Pure domain entity representing a wishlist item.
@immutable
class WishlistItemEntity {
  final String id;
  final String userId;
  final String productId;
  final DateTime addedAt;
  final String? productName;
  final double? productPrice;
  final String? productImageUrl;

  const WishlistItemEntity({
    required this.id,
    required this.userId,
    required this.productId,
    required this.addedAt,
    this.productName,
    this.productPrice,
    this.productImageUrl,
  });

  WishlistItemEntity copyWith({
    String? id,
    String? userId,
    String? productId,
    DateTime? addedAt,
    String? productName,
    double? productPrice,
    String? productImageUrl,
  }) {
    return WishlistItemEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      addedAt: addedAt ?? this.addedAt,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productImageUrl: productImageUrl ?? this.productImageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WishlistItemEntity &&
        other.id == id &&
        other.userId == userId &&
        other.productId == productId &&
        other.addedAt == addedAt &&
        other.productName == productName &&
        other.productPrice == productPrice &&
        other.productImageUrl == productImageUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      productId,
      addedAt,
      productName,
      productPrice,
      productImageUrl,
    );
  }

  @override
  String toString() {
    return 'WishlistItemEntity(id: $id, userId: $userId, productId: $productId)';
  }
}
