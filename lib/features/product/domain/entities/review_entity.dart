import 'package:flutter/foundation.dart';

/// Pure domain entity representing a product review.
@immutable
class ReviewEntity {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String comment;
  final double rating;
  final bool isVerifiedPurchase;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.comment,
    required this.rating,
    this.isVerifiedPurchase = false,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ReviewEntity copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? comment,
    double? rating,
    bool? isVerifiedPurchase,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          userId == other.userId &&
          userName == other.userName &&
          userPhotoUrl == other.userPhotoUrl &&
          comment == other.comment &&
          rating == other.rating &&
          isVerifiedPurchase == other.isVerifiedPurchase &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
        id,
        productId,
        userId,
        userName,
        userPhotoUrl,
        comment,
        rating,
        isVerifiedPurchase,
        createdAt,
        updatedAt,
      );

  @override
  String toString() => 'ReviewEntity(id: $id, userName: $userName, rating: $rating)';
}
