import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

/// Top-level function for background isolate execution via [compute]
/// ensuring large cart payloads don't freeze the UI.
List<CartItemModel> parseCartItemsList(dynamic rawData) {
  if (rawData == null) return [];

  dynamic targetData = rawData;
  if (rawData is! String && rawData is! Map && rawData is! List) {
    try {
      targetData = (rawData as dynamic).data ?? rawData;
    } catch (_) {}
  }

  if (targetData is String) {
    try {
      targetData = jsonDecode(rawData);
    } catch (e) {
      throw ParsingException(
        message: 'فشل في قراءة بيانات السلة كـ JSON',
        originalError: e,
      );
    }
  }

  if (targetData is Map) {
    targetData = targetData['items'] ?? targetData['data'] ?? targetData['cart'];
  }

  if (targetData is! List) return [];

  final List<CartItemModel> items = [];
  for (final element in targetData) {
    if (element is Map) {
      try {
        items.add(CartItemModel.safeFromJson(Map<String, dynamic>.from(element)));
      } catch (_) {
        // Skip malformed individual items rather than crashing the entire list
      }
    }
  }
  return items;
}

@freezed
class CartItemModel with _$CartItemModel {
  @HiveType(typeId: 0, adapterName: 'CartItemModelAdapter')
  const factory CartItemModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'user_id') required String userId,
    @HiveField(2) required ProductModel product,
    @HiveField(3) @Default(1) int quantity,
    @HiveField(4) @JsonKey(name: 'added_at') DateTime? addedAt,
    @HiveField(5) @JsonKey(name: 'selected_flavor') String? selectedFlavor,
    @HiveField(6) @JsonKey(name: 'selected_size') String? selectedSize,
  }) = _CartItemModel;

  const CartItemModel._();

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  /// Safe parsing with fallbacks preventing TypeError and NullPointer crashes.
  factory CartItemModel.safeFromJson(Map<String, dynamic> json) {
    final rawProduct = json['product'] ?? json['product_details'];
    final ProductModel parsedProduct;
    if (rawProduct is Map<String, dynamic>) {
      parsedProduct = ProductModel.fromJson(_normalizeProductJson(rawProduct));
    } else if (rawProduct is Map) {
      parsedProduct = ProductModel.fromJson(
        _normalizeProductJson(Map<String, dynamic>.from(rawProduct)),
      );
    } else {
      throw const ParsingException(message: 'بيانات المنتج في السلة غير متوفرة أو تالفة');
    }

    final rawQuantity = json['quantity'];
    final int parsedQty = rawQuantity is int
        ? rawQuantity
        : (int.tryParse(rawQuantity?.toString() ?? '') ?? 1);

    return CartItemModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: json['user_id']?.toString() ?? json['userId']?.toString() ?? '',
      product: parsedProduct,
      quantity: parsedQty > 0 ? parsedQty : 1,
      addedAt: json['added_at'] != null ? DateTime.tryParse(json['added_at'].toString()) : null,
      selectedFlavor: json['selected_flavor']?.toString() ?? json['flavor']?.toString(),
      selectedSize: json['selected_size']?.toString() ?? json['size']?.toString(),
    );
  }

  static Map<String, dynamic> _normalizeProductJson(Map<String, dynamic> map) {
    final cleanMap = Map<String, dynamic>.from(map);

    if (cleanMap['price'] is String) {
      cleanMap['price'] = double.tryParse(cleanMap['price'] as String) ?? 0.0;
    } else if (cleanMap['price'] is num) {
      cleanMap['price'] = (cleanMap['price'] as num).toDouble();
    }

    if (cleanMap['discount_price'] is String) {
      cleanMap['discount_price'] =
          double.tryParse(cleanMap['discount_price'] as String);
    } else if (cleanMap['discount_price'] is num) {
      cleanMap['discount_price'] =
          (cleanMap['discount_price'] as num).toDouble();
    }

    if (cleanMap['stock_quantity'] is String) {
      cleanMap['stock_quantity'] =
          int.tryParse(cleanMap['stock_quantity'] as String) ?? 0;
    }

    if (cleanMap['average_rating'] is String) {
      cleanMap['average_rating'] =
          double.tryParse(cleanMap['average_rating'] as String) ?? 0.0;
    }

    if (cleanMap['review_count'] is String) {
      cleanMap['review_count'] =
          int.tryParse(cleanMap['review_count'] as String) ?? 0;
    }

    if (cleanMap['name'] is String) {
      final nameStr = cleanMap['name'] as String;
      cleanMap['name'] = {'ar': nameStr, 'en': nameStr};
    }

    if (cleanMap['imageUrls'] == null && cleanMap['image_urls'] != null) {
      final rawImages = cleanMap['image_urls'];
      if (rawImages is List) {
        cleanMap['imageUrls'] = rawImages.map((img) {
          if (img is Map) {
            return {
              'thumbnail': img['thumbnail'] ?? img['original'] ?? img['medium'] ?? '',
              'medium': img['medium'] ?? img['original'] ?? img['thumbnail'] ?? '',
              'original': img['original'] ?? img['medium'] ?? img['thumbnail'] ?? '',
            };
          } else if (img is String) {
            return {
              'thumbnail': img,
              'medium': img,
              'original': img,
            };
          }
          return {'thumbnail': '', 'medium': '', 'original': ''};
        }).toList();
      }
    }

    return cleanMap;
  }

  double get subtotal =>
      product.getEffectivePriceForSize(selectedSize) * quantity;
  String? get primaryImageUrl =>
      product.imageUrls.isNotEmpty ? product.imageUrls.first.medium : null;
}
