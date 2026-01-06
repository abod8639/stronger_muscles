import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductDetailsController extends GetxController {
  final ProductModel product;
  final RxBool isInWishlist = false.obs;
  RxInt selectedImageIndex = 0.obs;
  late Box<String> wishlistBox;

  ProductDetailsController(this.product);

  @override
  void onInit() {
    super.onInit();
    _initWishlist();
  }

  Future<void> _initWishlist() async {
    try {
      if (!Hive.isBoxOpen('wishlist')) {
        wishlistBox = await Hive.openBox<String>('wishlist');
      } else {
        wishlistBox = Hive.box<String>('wishlist');
      }
      isInWishlist.value = wishlistBox.containsKey(product.id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to access wishlist: $e');
    }
  }

  void toggleWishlist() {
    try {
      if (isInWishlist.value) {
        wishlistBox.delete(product.id);
      } else {
        // Store full product JSON so wishlist can load without external repository
        wishlistBox.put(product.id, jsonEncode(product.toJson()));
      }
      isInWishlist.toggle();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update wishlist: $e');
    }
  }

  void selectImage(int index) => selectedImageIndex.value = index;
}
