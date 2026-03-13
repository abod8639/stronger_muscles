import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';

part 'product_details_controller.g.dart';

class ProductDetailsState {
  final int selectedImageIndex;
  final String selectedFlavor;
  final ProductSize? selectedSizeObject;
  final bool isInWishlist;

  ProductDetailsState({
    this.selectedImageIndex = 0,
    this.selectedFlavor = "",
    this.selectedSizeObject,
    this.isInWishlist = false,
  });

  ProductDetailsState copyWith({
    int? selectedImageIndex,
    String? selectedFlavor,
    ProductSize? selectedSizeObject,
    bool? isInWishlist,
  }) {
    return ProductDetailsState(
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedFlavor: selectedFlavor ?? this.selectedFlavor,
      selectedSizeObject: selectedSizeObject ?? this.selectedSizeObject,
      isInWishlist: isInWishlist ?? this.isInWishlist,
    );
  }
}

@riverpod
class ProductDetailsController extends _$ProductDetailsController {
  @override
  ProductDetailsState build(
    ProductModel product, {
    String? initialFlavor,
    String? initialSize,
  }) {
    final wishlistService = ref.watch(wishlistServiceProvider.notifier);

    final flavor =
        initialFlavor ??
        (product.flavors.isNotEmpty ? product.flavors.first : "");

    ProductSize? sizeObj;
    if (product.productSizes.isNotEmpty) {
      if (initialSize != null) {
        sizeObj = product.productSizes.firstWhere(
          (s) => s.size == initialSize,
          orElse: () => product.productSizes.first,
        );
      } else {
        sizeObj = product.productSizes.first;
      }
    }

    return ProductDetailsState(
      selectedFlavor: flavor,
      selectedSizeObject: sizeObj,
      isInWishlist: wishlistService.isFavorite(product.id),
    );
  }

  void selectImage(int index) {
    state = state.copyWith(selectedImageIndex: index);
  }

  void toggleWishlist(ProductModel product) {
    final wishlistService = ref.read(wishlistServiceProvider.notifier);
    wishlistService.toggleFavorite(product);
    state = state.copyWith(
      isInWishlist: wishlistService.isFavorite(product.id),
    );
  }

  void updateFlavor(String flavor) {
    state = state.copyWith(selectedFlavor: flavor);
  }

  void updateSize(ProductModel product, String sizeName) {
    if (product.productSizes.isNotEmpty) {
      final sizeObj = product.productSizes.firstWhere(
        (s) => s.size == sizeName,
        orElse: () => state.selectedSizeObject!,
      );
      state = state.copyWith(selectedSizeObject: sizeObj);
    }
  }

  double getDisplayPrice(ProductModel product) =>
      product.getPriceForSize(state.selectedSizeObject?.size);

  double getDisplayEffectivePrice(ProductModel product) =>
      product.getEffectivePriceForSize(state.selectedSizeObject?.size);

  bool getDisplayHasDiscount(ProductModel product) =>
      product.hasDiscountForSize(state.selectedSizeObject?.size);
}
