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
    wishlistBox = Hive.box<String>('wishlist');
    // Listen to box changes
    _wishlistSubscription = wishlistBox.watch().listen((event) {
      _loadWishlistItems();
    });
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
  }

  void addToWishlist(ProductModel product) {
    // The listener will automatically update the UI
    if (!wishlistBox.containsKey(product.id)) {
      wishlistBox.put(product.id, product.id);
    }
  }

  void removeFromWishlist(ProductModel product) {
    // The listener will automatically update the UI
    wishlistBox.delete(product.id);
  }
}
