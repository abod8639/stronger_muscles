
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class WishlistController extends GetxController {
  final RxList<ProductModel> wishlistItems = <ProductModel>[].obs;
  late Box<String> wishlistBox;

  @override
  void onInit() {
    super.onInit();
    wishlistBox = Hive.box<String>('wishlist');
    // In a real app, you would fetch product details based on the IDs stored in the wishlistBox
    // For now, we'll just add dummy products if the wishlist is not empty
    if (wishlistBox.isNotEmpty) {
      wishlistItems.assignAll([
        ProductModel(
          id: '1',
          name: 'Whey Protein',
          price: 59.99,
          imageUrl: 'https://wayupsports.com/cdn/shop/files/10843.jpg?v=1756650182&width=1000',
          description: 'High-quality whey protein for muscle growth.',
        ),
        ProductModel(
          id: '2',
          name: 'Creatine Monohydrate',
          price: 29.99,
          imageUrl: 'https://wayupsports.com/cdn/shop/files/10821_368621d1-1d16-402a-93e0-f1c9f0e146af.jpg?v=1692179491&width=1000',
          description: 'Pure creatine for increased strength and performance.',
        ),
      ]);
    }
  }

  void addToWishlist(ProductModel product) {
    if (!wishlistBox.containsKey(product.id)) {
      wishlistBox.put(product.id, product.id);
      wishlistItems.add(product);
    }
  }

  void removeFromWishlist(ProductModel product) {
    wishlistBox.delete(product.id);
    wishlistItems.removeWhere((item) => item.id == product.id);
  }
}
