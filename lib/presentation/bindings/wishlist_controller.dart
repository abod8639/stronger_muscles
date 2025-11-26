import 'dart:async';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';

class WishlistController extends GetxController {
  final RxList<ProductModel> wishlistItems = <ProductModel>[].obs;
  late Box<String> wishlistBox;
  final ProductRepository _productRepository = ProductRepository();
  StreamSubscription<BoxEvent>? _wishlistSubscription;

  @override
  void onInit() {
    super.onInit();
    _initBox();
  }

  Future<void> _initBox() async {
    try {
      if (!Hive.isBoxOpen('wishlist')) {
        wishlistBox = await Hive.openBox<String>('wishlist');
      } else {
        wishlistBox = Hive.box<String>('wishlist');
      }
      // Listen to box changes
      _wishlistSubscription = wishlistBox.watch().listen((event) {
        _loadWishlistItems();
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize wishlist: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
    _loadWishlistItems();
  }

  @override
  void onClose() {
    _wishlistSubscription?.cancel();
    super.onClose();
  }

  Future<void> _loadWishlistItems() async {
    try {
      // Using a temporary list to avoid multiple UI updates while looping
      final List<ProductModel> items = [];
      for (var productId in wishlistBox.keys) {
        final product = await _productRepository.getProductById(productId);
        if (product != null) {
          items.add(product);
        } else {
          developer.log(
            'Warning: Product with ID $productId not found.',
            name: 'WishlistController',
            level: 900, // WARNING
          );
        }
      }
      // Assign all at once to trigger a single UI update
      wishlistItems.assignAll(items);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wishlist items: $e');
    }
  }

  void addToWishlist(ProductModel product) {
    try {
      // The listener will automatically update the UI
      if (!wishlistBox.containsKey(product.id)) {
        wishlistBox.put(product.id, product.id);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to wishlist: $e');
    }
  }

  void removeFromWishlist(ProductModel product) {
    try {
      // The listener will automatically update the UI
      wishlistBox.delete(product.id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from wishlist: $e');
    }
  }
}
