
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductDetailsController extends GetxController {
  final ProductModel product;
  final RxBool isInWishlist = false.obs;
  RxInt selectedImageIndex = 0.obs;
  late Box<String> wishlistBow;

  ProductDetailsController(this.product);

  @override
  void onInit() {
    super.onInit();
    wishlistBow = Hive.box<String>('wishlist');
    isInWishlist.value = wishlistBow.containsKey(product.id);
  }

  void toggleWishlist() {
    if (isInWishlist.value) {
      wishlistBow.delete(product.id);
    } else {
      wishlistBow.put(product.id, product.id);
    }
    isInWishlist.toggle();
  }
void selectImage(int index) => selectedImageIndex.value = index;

}
