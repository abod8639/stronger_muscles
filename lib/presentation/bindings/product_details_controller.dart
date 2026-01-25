import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductDetailsController extends GetxController {
  final ProductModel product;
  final WishlistService _wishlistService = Get.find<WishlistService>();

  // التفاعليات
  final RxBool isInWishlist = false.obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxString selectedFlavor = "".obs;
  final RxString selectedSize = "".obs;
  
  final ScrollController imageScrollController = ScrollController();

  ProductDetailsController(this.product, {String? initialFlavor, String? initialSize}) {
    selectedFlavor.value = initialFlavor ?? 
        (product.flavors?.isNotEmpty == true ? product.flavors!.first : "");
        
    selectedSize.value = initialSize ?? 
        (product.size?.isNotEmpty == true ? product.size!.first : "");
  }

  @override
  void onInit() {
    super.onInit();
    _checkInitialWishlistStatus();
  }

  void _checkInitialWishlistStatus() {
    isInWishlist.value = _wishlistService.isFavorite(product.id);
  }

  void toggleWishlist() {
    try {
      _wishlistService.toggleFavorite(product);
      isInWishlist.toggle();
    } catch (e) {
      _showErrorSnackbar('Update failed', e.toString());
    }
  }

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    imageScrollController.dispose();
    super.onClose();
  }
}