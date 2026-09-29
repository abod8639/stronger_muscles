import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/wishlist/domain/usecases/usecase_providers.dart';

part 'wishlist_controller.g.dart';

@riverpod
class WishlistController extends _$WishlistController {
  @override
  List<ProductModel> build() {
    final getWishlist = ref.watch(getWishlistUseCaseProvider);
    return getWishlist();
  }

  void addToWishlist(ProductModel product) {
    final addUseCase = ref.read(addToWishlistUseCaseProvider);
    addUseCase(product);
    state = [...state, product];
  }

  void removeFromWishlist(ProductModel product) {
    final removeUseCase = ref.read(removeFromWishlistUseCaseProvider);
    removeUseCase(product);
    state = state.where((item) => item.id != product.id).toList();
  }

  bool isInWishlist(String productId) {
    final isInWishlistUseCase = ref.read(isInWishlistUseCaseProvider);
    return isInWishlistUseCase(productId);
  }
}
