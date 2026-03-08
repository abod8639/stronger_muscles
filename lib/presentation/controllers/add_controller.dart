import 'dart:async';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/base_controller.dart';
import 'package:flutter/material.dart';

class PromoModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String buttonText;
  final Color backgroundColor;

  PromoModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.buttonText,
    required this.backgroundColor,
  });
}

class AddController extends BaseController {
  final RxList<PromoModel> promos = <PromoModel>[].obs;
  final RxInt currentIndex = 0.obs;
  late final PageController pageController;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    _loadPromotions();
    _startAutoPlay();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void _loadPromotions() {
    // Mock data for products advertisements
    promos.assignAll([
      PromoModel(
        title: "خصم 50% على البروتين",
        subtitle: "أفضل المكملات لزيادة العضلات بأسرع وقت",
        imageUrl:
            "https://images.unsplash.com/photo-1579722820308-d74e571900a9?q=80&w=2070&auto=format&fit=crop",
        buttonText: "تسوق الآن",
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      PromoModel(
        title: "تخفيضات العيد الرياضية",
        subtitle: "معدات رياضية بأقل الأسعار لفترة محدودة",
        imageUrl:
            "https://images.unsplash.com/photo-1540497077202-7c8a3999166f?q=80&w=2070&auto=format&fit=crop",
        buttonText: "اكتشف العروض",
        backgroundColor: const Color(0xFF8B0000),
      ),
      PromoModel(
        title: "وصل حديثاً",
        subtitle: "ملابس رياضية مصممة للراحة والأداء العالي",
        imageUrl:
            "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2070&auto=format&fit=crop",
        buttonText: "تصفح التشكيلة",
        backgroundColor: const Color(0xFF0D47A1),
      ),
    ]);
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (promos.isEmpty) return;
      int nextIndex = (currentIndex.value + 1) % promos.length;
      if (pageController.hasClients) {
        pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void onPromoPressed(PromoModel promo) {
    // Navigate to products by category or promotional page
    Get.snackbar(
      "عرض ترويجي",
      "تم الضغط على: ${promo.title}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }
}
