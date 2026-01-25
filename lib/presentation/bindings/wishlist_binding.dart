import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}
