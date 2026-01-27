import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
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
  final RxString selectedSize = "".obs;

  // التحكم في العرض (UI Controllers)
  late final PageController pageController;

  ProductDetailsController(
    this.product, {
    String? initialFlavor,
    String? initialSize,
  }) {
    // تحديد القيم الابتدائية للنكهة والحجم
    selectedFlavor.value = initialFlavor ?? 
        (product.flavors?.isNotEmpty == true ? product.flavors!.first : "");

    selectedSize.value = initialSize ?? 
        (product.size?.isNotEmpty == true ? product.size!.first : "");
  }

  @override
  void onInit() {
    super.onInit();
    // تهيئة PageController مع الصفحة المختارة ابتدائياً
    pageController = PageController(initialPage: selectedImageIndex.value);
    _checkInitialWishlistStatus();
    _precacheAllImages();
  }

  void _checkInitialWishlistStatus() {
    isInWishlist.value = _wishlistService.isFavorite(product.id);
  }

  // ميزة الـ Wishlist مع معالجة الأخطاء
  void toggleWishlist() {
    try {
      _wishlistService.toggleFavorite(product);
      isInWishlist.toggle();
    } catch (e) {
      _showErrorSnackbar(_updateFailedErrorMsg, e.toString());
    }
  }

  // تحسين: التزامن بين الـ PageView والـ Index
  void selectImage(int index) {
    if (selectedImageIndex.value == index) return;
    
    selectedImageIndex.value = index;
    
    // التحقق من وجود مستخدم واحد فقط متصل لتجنب AssertionError
    if (pageController.hasClients) {
      // التأكد من أن الـ Controller متصل بـ View واحد فقط قبل قراءة الخاصية .page
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
  void updateSize(String size) => selectedSize.value = size;

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
    // إغلاق الـ Controller بشكل صحيح لمنع تسريب الذاكرة
    pageController.dispose();
    super.onClose();
  }

  void _precacheAllImages() {
    for (var url in product.imageUrls) {
      precacheImage(
        CachedNetworkImageProvider(
          url,
          cacheManager: CustomCacheManager.instance,
        ),
        Get.context!,
      );
    }
  }
}