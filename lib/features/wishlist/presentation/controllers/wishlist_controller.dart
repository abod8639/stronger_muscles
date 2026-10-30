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

  /// Removes a product from the wishlist optimistically: it leaves the list
  /// immediately (a swipe-dismissed row cannot stay in the tree) and is put
  /// back at the same position if the removal fails.
  Future<void> removeFromWishlist(dynamic product) async {
    final String id = product is ProductEntity
        ? product.id
        : (product is ProductModel ? product.id : product.toString());

    final index = state.indexWhere((item) => item.id == id);
    final ProductEntity entity = product is ProductEntity
        ? product
        : (product is ProductModel
            ? product.toEntity()
            : (index >= 0 ? state[index] : ProductEntity(id: id)));

    state = state.where((item) => item.id != id).toList();

    final result = await ref.read(removeFromWishlistUseCaseProvider)(entity);

    result.fold(
      (failure) {
        if (index < 0 || state.any((item) => item.id == id)) return;
        state = [...state]..insert(index.clamp(0, state.length), entity);
      },
      (_) {},
    );
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
