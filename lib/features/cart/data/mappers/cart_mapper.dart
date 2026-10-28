import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

/// Extension mapper to convert [CartItemModel] DTO to [CartItemEntity] pure domain entity.
extension CartItemModelMapper on CartItemModel {
  CartItemEntity toEntity() => CartItemEntity(
        id: id,
        userId: userId,
        product: product.toEntity(),
        quantity: quantity,
        addedAt: addedAt,
        selectedFlavor: selectedFlavor,
        selectedSize: selectedSize,
      );
}

/// Extension mapper to convert [CartItemEntity] domain entity to [CartItemModel] DTO.
extension CartItemEntityMapper on CartItemEntity {
  CartItemModel toModel() => CartItemModel(
        id: id,
        userId: userId,
        product: ProductModel.fromEntity(product),
        quantity: quantity,
        addedAt: addedAt,
        selectedFlavor: selectedFlavor,
        selectedSize: selectedSize,
      );
}
