import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/usecase_providers.dart';

part 'wishlist_controller.g.dart';

@riverpod
class WishlistController extends _$WishlistController {
  @override
  List<ProductEntity> build() {
    final getWishlist = ref.watch(getWishlistUseCaseProvider);
    return getWishlist();
  }

  /// Adds a product to the wishlist.
  /// Accepts both [ProductEntity] and [ProductModel] for seamless compatibility.
  void addToWishlist(dynamic product) {
    final ProductEntity entity = product is ProductEntity
        ? product
        : (product as ProductModel).toEntity();
    final addUseCase = ref.read(addToWishlistUseCaseProvider);
    addUseCase(entity);
    state = [...state.where((item) => item.id != entity.id), entity];
  }

  /// Removes a product from the wishlist.
  /// Accepts [ProductEntity], [ProductModel], or a product id [String].
  void removeFromWishlist(dynamic product) {
    final String id = product is ProductEntity
        ? product.id
        : (product is ProductModel ? product.id : product.toString());
    final ProductEntity entity = product is ProductEntity
        ? product
        : (product is ProductModel
            ? product.toEntity()
            : state.firstWhere(
                (item) => item.id == id,
                orElse: () => ProductEntity(id: id),
              ));
    final removeUseCase = ref.read(removeFromWishlistUseCaseProvider);
    removeUseCase(entity);
    state = state.where((item) => item.id != id).toList();
  }

  /// Checks if a product exists in the wishlist by its id.
  bool isInWishlist(String productId) {
    final isInWishlistUseCase = ref.read(isInWishlistUseCaseProvider);
    return isInWishlistUseCase(productId);
  }
}

