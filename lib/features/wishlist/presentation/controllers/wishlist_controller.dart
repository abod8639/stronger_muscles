import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/wishlist_providers.dart';

part 'wishlist_controller.g.dart';

/// State management controller for the Wishlist feature.
/// Enforces immutable state updates, strict guard clauses against duplicate
/// mutations, and zero try-catch blocks via functional error handling.
@riverpod
class WishlistController extends _$WishlistController {
  bool _isMutating = false;

  @override
  List<ProductEntity> build() {
    final getWishlist = ref.watch(getWishlistUseCaseProvider);
    // Instant synchronous read from local cache
    final initialList = getWishlist.getCached().fold(
      (failure) => <ProductEntity>[],
      (items) => items,
    );

    // Asynchronously synchronize with remote repository
    _syncFromRemote();

    return initialList;
  }

  /// Adds a product to the wishlist with mutation guard and immutable state update.
  Future<void> addToWishlist(dynamic product) async {
    if (_isMutating) return;
    _isMutating = true;

    final ProductEntity entity;
    if (product is ProductEntity) {
      entity = product;
    } else if (product is ProductModel) {
      entity = product.toEntity();
    } else {
      entity = ProductEntity(id: product.toString());
    }

    final addUseCase = ref.read(addToWishlistUseCaseProvider);
    final result = await addUseCase(entity);

    result.fold(
      (failure) {
        // Handled via functional Either without throwing
      },
      (_) {
        // Enforce immutable state update
        state = [...state.where((item) => item.id != entity.id), entity];
      },
    );

    _isMutating = false;
  }

  /// Removes a product from the wishlist with mutation guard and immutable state update.
  Future<void> removeFromWishlist(dynamic product) async {
    if (_isMutating) return;
    _isMutating = true;

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
    final result = await removeUseCase(entity);

    result.fold(
      (failure) {
        // Handled via functional Either without throwing
      },
      (_) {
        // Enforce immutable state update
        state = state.where((item) => item.id != id).toList();
      },
    );

    _isMutating = false;
  }

  /// Checks if a product exists in the wishlist using UseCase and local state fallback.
  bool isInWishlist(String productId) {
    final isInWishlistUseCase = ref.read(isInWishlistUseCaseProvider);
    return isInWishlistUseCase(productId).fold(
      (failure) => state.any((item) => item.id == productId),
      (inWishlist) => inWishlist || state.any((item) => item.id == productId),
    );
  }

  /// Manually refreshes the wishlist items from remote/local repository.
  Future<void> refresh() async {
    await _syncFromRemote();
  }

  Future<void> _syncFromRemote() async {
    final getWishlist = ref.read(getWishlistUseCaseProvider);
    final result = await getWishlist();
    result.fold(
      (failure) {
        // Silently preserve cached items if remote fails
      },
      (remoteItems) {
        if (remoteItems.isNotEmpty || state.isEmpty) {
          state = remoteItems;
        }
      },
    );
  }
}
