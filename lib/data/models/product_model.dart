import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 5)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final double? discountPrice;

  @HiveField(4)
  final List<String> imageUrls;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String categoryId;

  @HiveField(7)
  final int stockQuantity;

  @HiveField(8)
  final double averageRating;

  @HiveField(9)
  final int reviewCount;

  @HiveField(10)
  final String? brand;

  @HiveField(11)
  final String? servingSize;

  @HiveField(12)
  final int? servingsPerContainer;

  @HiveField(13)
  final bool isActive;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.discountPrice,
    required this.imageUrls,
    required this.description,
    required this.categoryId,
    this.stockQuantity = 0,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.brand,
    this.servingSize,
    this.servingsPerContainer,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discountPrice']?.toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      stockQuantity: json['stockQuantity'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      brand: json['brand'],
      servingSize: json['servingSize'],
      servingsPerContainer: json['servingsPerContainer'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'discountPrice': discountPrice,
        'imageUrls': imageUrls,
        'description': description,
        'categoryId': categoryId,
        'stockQuantity': stockQuantity,
        'averageRating': averageRating,
        'reviewCount': reviewCount,
        'brand': brand,
        'servingSize': servingSize,
        'servingsPerContainer': servingsPerContainer,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Get effective price (considering discount)
  double get effectivePrice => discountPrice ?? price;

  /// Check if product has discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  /// Get discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountPrice!) / price * 100).roundToDouble();
  }

  /// Check if product is in stock
  bool get isInStock => stockQuantity > 0;

  /// Create a copy with updated fields
  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    double? discountPrice,
    List<String>? imageUrls,
    String? description,
    String? categoryId,
    int? stockQuantity,
    double? averageRating,
    int? reviewCount,
    String? brand,
    String? servingSize,
    int? servingsPerContainer,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrls: imageUrls ?? this.imageUrls,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      brand: brand ?? this.brand,
      servingSize: servingSize ?? this.servingSize,
      servingsPerContainer: servingsPerContainer ?? this.servingsPerContainer,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
