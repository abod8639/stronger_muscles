import 'package:hive/hive.dart';

part 'ReviewModel.g.dart';

@HiveType(typeId: 8)
class ReviewModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String userName; // Snapshot for display

  @HiveField(4)
  final String? userPhotoUrl;

  @HiveField(5)
  final String comment;

  @HiveField(6)
  final double rating; // 1.0 - 5.0

  @HiveField(7)
  final bool isVerifiedPurchase;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  ReviewModel({
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

  /// Factory constructor to create ReviewModel from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhotoUrl: json['userPhotoUrl'],
      comment: json['comment'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      isVerifiedPurchase: json['isVerifiedPurchase'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// Convert ReviewModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'userId': userId,
        'userName': userName,
        'userPhotoUrl': userPhotoUrl,
        'comment': comment,
        'rating': rating,
        'isVerifiedPurchase': isVerifiedPurchase,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// Create a copy with updated fields
  ReviewModel copyWith({
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
    return ReviewModel(
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

  /// Get rating as integer (for star display)
  int get ratingStars => rating.round();

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
}
