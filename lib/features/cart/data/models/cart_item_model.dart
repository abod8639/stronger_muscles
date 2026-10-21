import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

/// Top-level function for background isolate execution via [compute]
/// ensuring large cart payloads don't freeze the UI.
List<CartItemModel> parseCartItemsList(dynamic rawData) {
  if (rawData == null) return [];

  dynamic targetData = rawData;
  if (rawData is String) {
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
      parsedProduct = ProductModel.fromJson(rawProduct);
    } else if (rawProduct is Map) {
      parsedProduct = ProductModel.fromJson(Map<String, dynamic>.from(rawProduct));
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

  double get subtotal =>
      product.getEffectivePriceForSize(selectedSize) * quantity;
  String? get primaryImageUrl =>
      product.imageUrls.isNotEmpty ? product.imageUrls.first.medium : null;

  /// Converts this data model to the domain entity [CartItemEntity].
  CartItemEntity toEntity() => CartItemEntity(
        id: id,
        userId: userId,
        product: product.toEntity(),
        quantity: quantity,
        addedAt: addedAt,
        selectedFlavor: selectedFlavor,
        selectedSize: selectedSize,
      );

  /// Creates a data model from domain entity [CartItemEntity].
  static CartItemModel fromEntity(CartItemEntity entity) => CartItemModel(
        id: entity.id,
        userId: entity.userId,
        product: ProductModel.fromEntity(entity.product),
        quantity: entity.quantity,
        addedAt: entity.addedAt,
        selectedFlavor: entity.selectedFlavor,
        selectedSize: entity.selectedSize,
      );
}
