import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductImageController extends GetxController {
  final selectedImageIndex = 0.obs;
  final PageController pageController = PageController();

  void selectImage(int index) {
    if (index == selectedImageIndex.value) return;
    selectedImageIndex.value = index;
    // animate the page view to the selected index
    try {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (_) {}
  }

  void onPageChanged(int index) {
    selectedImageIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
