import 'dart:async';
import 'package:get/get.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/base_controller.dart';
import 'package:flutter/material.dart';



class PromoController extends BaseController {
  final RxList<PromoModel> promos = <PromoModel>[].obs;
  final RxInt currentIndex = 0.obs;
  late final PageController pageController;
  Timer? _timer;
  final int initialPage = 10000;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: initialPage);
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
    promos.assignAll([
      PromoModel(
        id: 1,
        targetType: "product",
        targetId: "1",
        title: "خصم 50% على البروتين",
        subtitle: "أفضل المكملات لزيادة العضلات بأسرع وقت",
        imageUrl:
            "https://images.unsplash.com/photo-1579722820308-d74e571900a9?q=80&w=2070&auto=format&fit=crop",
        buttonText: "تسوق الآن",
        hexBackgroundColor: "#1E1E1E",
       ),
      PromoModel(
        id: 2,
        targetType: "category",
        targetId: "2",
        title: "تخفيضات العيد الرياضية",
        subtitle: "معدات رياضية بأقل الأسعار لفترة محدودة",
        imageUrl:
            "https://images.unsplash.com/photo-1540497077202-7c8a3999166f?q=80&w=2070&auto=format&fit=crop",
        buttonText: "اكتشف العروض",
        hexBackgroundColor: "#8B0000",
      ),
      PromoModel(
        id: 3,
        targetType: "web",
        targetId: "https://www.google.com",
        title: "وصل حديثاً",
        subtitle: "مكملات غذائيه صممت خصيصا لتعزيز ادائك",
        imageUrl:
            "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2070&auto=format&fit=crop",
        buttonText: "تصفح التشكيلة",
        hexBackgroundColor: "#0D47A1",
      ),
      PromoModel(
        id: 4,
        targetType: "web",
        targetId: "https://www.google.com",
        title: "وصل حديثاً",
        subtitle: "مكملات غذائيه صممت خصيصا لتعزيز ادائك",
        imageUrl:
            "https://eg.bigramylabs.com/cdn/shop/files/Desktop--AR--Ramdan.png",
        buttonText: "تصفح التشكيلة",
        hexBackgroundColor: "#0D47A1",
      ),
      PromoModel(
        id: 5,
        targetType: "web",
        targetId: "https://www.google.com",
        imageUrl:
            "https://eg.bigramylabs.com/cdn/shop/files/Best-seller-_-AR.png",
        buttonText: "تصفح التشكيلة",
        hexBackgroundColor: "#0D47A1",
      ),
    ]);
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (promos.isEmpty || !pageController.hasClients) return;

      int nextPage = pageController.page!.round() + 1;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void updateCurrentIndex(int index) {
    if (promos.isEmpty) return;
    currentIndex.value = index % promos.length;
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



