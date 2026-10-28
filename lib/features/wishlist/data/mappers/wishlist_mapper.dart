import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:stronger_muscles/features/wishlist/domain/entities/wishlist_item_entity.dart';

/// Extension mapper converting [WishlistItemModel] to pure [WishlistItemEntity].
extension WishlistItemModelMapper on WishlistItemModel {
  WishlistItemEntity toEntity() {
    return WishlistItemEntity(
      id: id,
      userId: userId,
      productId: productId,
      addedAt: addedAt,
      productName: productName,
      productPrice: productPrice,
      productImageUrl: productImageUrl,
    );
  }
}

/// Extension mapper converting [WishlistItemEntity] to [WishlistItemModel].
extension WishlistItemEntityMapper on WishlistItemEntity {
  WishlistItemModel toModel() {
    return WishlistItemModel(
      id: id,
      userId: userId,
      productId: productId,
      addedAt: addedAt,
      productName: productName,
      productPrice: productPrice,
      productImageUrl: productImageUrl,
    );
  }
}

/// Extension mapper converting [ProductEntity] to [WishlistItemModel] for wishlist persistence.
extension ProductToWishlistItemMapper on ProductEntity {
  WishlistItemModel toWishlistItemModel({String? userId}) {
    return WishlistItemModel(
      id: 'wish_$id',
      userId: userId ?? 'guest',
      productId: id,
      addedAt: DateTime.now(),
      productName: name?.en ?? name?.ar ?? '',
      productPrice: baseEffectivePrice,
      productImageUrl: primaryImageUrl ??
          (imageUrls.isNotEmpty ? imageUrls.first.medium : null),
    );
  }
}
