import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/models/product_size_model.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';

const int _imageAnimationDurationMs = 300;
const String _updateFailedErrorMsg = 'Update failed';

class ProductDetailsController extends GetxController {
  final ProductModel product;
  final WishlistService _wishlistService = Get.find<WishlistService>();

  // التفاعليات (Reactive States)
  final RxBool isInWishlist = false.obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxString selectedFlavor = "".obs;
  final Rx<ProductSize?> selectedSizeObject = Rx<ProductSize?>(null);

  // التحكم في العرض (UI Controllers)
  late final PageController pageController;

  ProductDetailsController(
    this.product, {
    String? initialFlavor,
    String? initialSize,
  }) {
    // تحديد القيم الابتدائية للنكهة والحجم
    selectedFlavor.value =
        initialFlavor ??
        (product.flavors.isNotEmpty == true ? product.flavors.first : "");

    // Priority for productSizes list over legacy size strings
    if (product.productSizes.isNotEmpty) {
      if (initialSize != null) {
        selectedSizeObject.value = product.productSizes.firstWhere(
            (s) => s.size == initialSize,
            orElse: () => product.productSizes.first);
      } else {
        selectedSizeObject.value = product.productSizes.first;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedImageIndex.value);
    _checkInitialWishlistStatus();
    _precacheAllImages();
  }

  void _checkInitialWishlistStatus() {
    isInWishlist.value = _wishlistService.isFavorite(product.id);
  }

  void toggleWishlist() {
    try {
      _wishlistService.toggleFavorite(product);
      isInWishlist.toggle();
    } catch (e) {
      _showErrorSnackbar(_updateFailedErrorMsg, e.toString());
    }
  }

  void selectImage(int index) {
    if (selectedImageIndex.value == index) return;

    selectedImageIndex.value = index;

    if (pageController.hasClients) {
      if (pageController.positions.length == 1) {
        if (pageController.page?.round() != index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: _imageAnimationDurationMs),
            curve: Curves.easeInOut,
          );
        }
      } else {
        // في حال وجود أكثر من View، نستخدم الـ jump أو الـ animate بدون فحص الـ page الحالي
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: _imageAnimationDurationMs),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void updateFlavor(String flavor) => selectedFlavor.value = flavor;

  void updateSize(String sizeName) {
    if (product.productSizes.isNotEmpty) {
      selectedSizeObject.value = product.productSizes.firstWhere(
        (s) => s.size == sizeName,
        orElse: () => selectedSizeObject.value!,
      );
    }
  }

  double get displayPrice =>
      product.getPriceForSize(selectedSizeObject.value?.size);

  double get displayEffectivePrice =>
      product.getEffectivePriceForSize(selectedSizeObject.value?.size);

  bool get displayHasDiscount =>
      product.hasDiscountForSize(selectedSizeObject.value?.size);

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _precacheAllImages() {
    for (var imageUrl in product.imageUrls) {
      precacheImage(
        CachedNetworkImageProvider(
          imageUrl.medium,
          cacheManager: CustomCacheManager.instance,
        ),
        Get.context!,
      );
    }
  }
}
