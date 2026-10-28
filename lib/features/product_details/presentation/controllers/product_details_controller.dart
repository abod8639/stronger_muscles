import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_state.dart';
import 'package:stronger_muscles/features/wishlist/wishlist_feature.dart';

export 'product_details_state.dart';

/// Parameters used to parameterize the [ProductDetailsController] family provider.
class ProductDetailsFamilyParams {
  final dynamic product;
  final String? initialFlavor;
  final String? initialSize;

  const ProductDetailsFamilyParams({
    required this.product,
    this.initialFlavor,
    this.initialSize,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetailsFamilyParams &&
          product?.id == other.product?.id &&
          initialFlavor == other.initialFlavor &&
          initialSize == other.initialSize;

  @override
  int get hashCode =>
      (product?.id).hashCode ^ initialFlavor.hashCode ^ initialSize.hashCode;
}

final _productDetailsControllerFamily = StateNotifierProvider.autoDispose.family<
    ProductDetailsController,
    ProductDetailsState,
    ProductDetailsFamilyParams
>((ref, params) {
  return ProductDetailsController(
    params.product,
    ref: ref,
    initialFlavor: params.initialFlavor,
    initialSize: params.initialSize,
  );
});

/// Family wrapper for [productDetailsControllerProvider] supporting flexible arguments.
class ProductDetailsControllerFamilyWrapper {
  const ProductDetailsControllerFamilyWrapper();

  AutoDisposeStateNotifierProvider<ProductDetailsController, ProductDetailsState>
      call(
    dynamic product, {
    String? initialFlavor,
    String? initialSize,
  }) {
    return _productDetailsControllerFamily(
      ProductDetailsFamilyParams(
        product: product,
        initialFlavor: initialFlavor,
        initialSize: initialSize,
      ),
    );
  }
}

const productDetailsControllerProvider = ProductDetailsControllerFamilyWrapper();

/// StateNotifier responsible for Product Details UI logic, selections, and price computations.
class ProductDetailsController extends StateNotifier<ProductDetailsState> {
  final dynamic product;
  final Ref? _ref;

  ProductDetailsController(
    this.product, {
    Ref? ref,
    WishlistController? wishlistController,
    String? initialFlavor,
    String? initialSize,
  })  : _ref = ref,
        super(
          _computeInitialState(
            product,
            ref: ref,
            wishlistController: wishlistController,
            initialFlavor: initialFlavor,
            initialSize: initialSize,
          ),
        );

  static ProductDetailsState _computeInitialState(
    dynamic product, {
    Ref? ref,
    WishlistController? wishlistController,
    String? initialFlavor,
    String? initialSize,
  }) {
    final flavors = _getFlavors(product);
    final flavor = initialFlavor ?? (flavors.isNotEmpty ? flavors.first : '');

    final sizes = _getProductSizes(product);
    dynamic sizeObj;
    if (sizes.isNotEmpty) {
      if (initialSize != null) {
        final match = sizes.where((s) => s.size == initialSize);
        sizeObj = match.isNotEmpty ? match.first : sizes.first;
      } else {
        sizeObj = sizes.first;
      }
    }

    bool inWishlist = false;
    final productId = product?.id?.toString() ?? '';
    if (wishlistController != null) {
      inWishlist = wishlistController.isInWishlist(productId);
    } else if (ref != null) {
      try {
        final wishlist = ref.read(wishlistControllerProvider.notifier);
        inWishlist = wishlist.isInWishlist(productId);
      } catch (_) {}
    }

    final price = _computePrice(product, sizeObj?.size);
    final effectivePrice = _computeEffectivePrice(product, sizeObj?.size);
    final hasDiscount = _computeHasDiscount(product, sizeObj?.size);

    return ProductDetailsState(
      selectedFlavor: flavor,
      selectedSizeObject: sizeObj,
      isInWishlist: inWishlist,
      displayPrice: price,
      displayEffectivePrice: effectivePrice,
      displayHasDiscount: hasDiscount,
      isPriceZero: effectivePrice <= 0,
    );
  }

  void selectImage(int index) {
    state = state.copyWith(selectedImageIndex: index);
  }

  void toggleWishlist(dynamic productToToggle) {
    final target = productToToggle ?? product;
    final productId = target?.id?.toString() ?? '';
    if (productId.isEmpty || _ref == null) return;

    final wishlistCtrl = _ref.read(wishlistControllerProvider.notifier);
    final currentlyIn = wishlistCtrl.isInWishlist(productId);

    if (currentlyIn) {
      wishlistCtrl.removeFromWishlist(target);
    } else {
      wishlistCtrl.addToWishlist(target);
    }

    state = state.copyWith(
      isInWishlist: wishlistCtrl.isInWishlist(productId),
    );
  }

  void updateFlavor(String flavor) {
    state = state.copyWith(selectedFlavor: flavor);
  }

  void updateSize(dynamic prod, String sizeName) {
    final target = prod ?? product;
    final sizes = _getProductSizes(target);
    if (sizes.isNotEmpty) {
      final match = sizes.where((s) => s.size == sizeName);
      final sizeObj = match.isNotEmpty ? match.first : state.selectedSizeObject;

      final price = _computePrice(target, sizeObj?.size);
      final effectivePrice = _computeEffectivePrice(target, sizeObj?.size);
      final hasDiscount = _computeHasDiscount(target, sizeObj?.size);

      state = state.copyWith(
        selectedSizeObject: sizeObj,
        displayPrice: price,
        displayEffectivePrice: effectivePrice,
        displayHasDiscount: hasDiscount,
        isPriceZero: effectivePrice <= 0,
      );
    }
  }

  double getDisplayPrice(dynamic prod) =>
      _computePrice(prod ?? product, state.selectedSizeObject?.size);

  double getDisplayEffectivePrice(dynamic prod) =>
      _computeEffectivePrice(prod ?? product, state.selectedSizeObject?.size);

  bool getDisplayHasDiscount(dynamic prod) =>
      _computeHasDiscount(prod ?? product, state.selectedSizeObject?.size);

  // Helper calculation logic moved out of UI widgets
  static List<String> _getFlavors(dynamic prod) {
    if (prod == null) return const [];
    if (prod is ProductModel) return prod.flavors;
    if (prod is ProductEntity) return prod.flavors;
    try {
      return (prod.flavors as List).map((e) => e.toString()).toList();
    } catch (_) {
      return const [];
    }
  }

  static List<dynamic> _getProductSizes(dynamic prod) {
    if (prod == null) return const [];
    if (prod is ProductModel) return prod.productSizes;
    if (prod is ProductEntity) return prod.productSizes;
    try {
      return (prod.productSizes as List).toList();
    } catch (_) {
      return const [];
    }
  }

  static double _computePrice(dynamic prod, String? sizeName) {
    if (prod == null) return 0.0;
    if (prod is ProductModel) return prod.getPriceForSize(sizeName);
    if (prod is ProductEntity) {
      if (sizeName != null && prod.productSizes.isNotEmpty) {
        final match = prod.productSizes.where((s) => s.size == sizeName);
        if (match.isNotEmpty) return match.first.price;
      }
      return prod.price;
    }
    return 0.0;
  }

  static double _computeEffectivePrice(dynamic prod, String? sizeName) {
    if (prod == null) return 0.0;
    if (prod is ProductModel) return prod.getEffectivePriceForSize(sizeName);
    if (prod is ProductEntity) {
      if (sizeName != null && prod.productSizes.isNotEmpty) {
        final match = prod.productSizes.where((s) => s.size == sizeName);
        if (match.isNotEmpty) {
          final size = match.first;
          return size.discountPrice ?? size.price;
        }
      }
      return prod.discountPrice ?? prod.price;
    }
    return 0.0;
  }

  static bool _computeHasDiscount(dynamic prod, String? sizeName) {
    if (prod == null) return false;
    if (prod is ProductModel) return prod.hasDiscountForSize(sizeName);
    if (prod is ProductEntity) {
      if (sizeName != null && prod.productSizes.isNotEmpty) {
        final match = prod.productSizes.where((s) => s.size == sizeName);
        if (match.isNotEmpty) {
          final size = match.first;
          return size.discountPrice != null && size.discountPrice! < size.price;
        }
      }
      return prod.discountPrice != null && prod.discountPrice! < prod.price;
    }
    return false;
  }
}
