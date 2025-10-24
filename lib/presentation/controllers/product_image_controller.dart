import 'package:get/get.dart';

class ProductImageController extends GetxController {
  final selectedImageIndex = 0.obs;

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  void onPageChanged(int index) {
    selectedImageIndex.value = index;
  }

  @override
  void onClose() {
  //  selectedImageIndex.value = 0;

    super.onClose();
  }
}
