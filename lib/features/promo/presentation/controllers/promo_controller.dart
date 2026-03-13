import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';

part 'promo_controller.g.dart';

@riverpod
class PromoController extends _$PromoController {
  Timer? _timer;
  late final PageController pageController;
  final int initialPage = 10000;

  @override
  int build() {
    pageController = PageController(initialPage: initialPage);
    _startAutoPlay();
    
    ref.onDispose(() {
      _timer?.cancel();
      pageController.dispose();
    });

    return 0; // Current index
  }

  List<PromoModel> get promos => [
        const PromoModel(
          id: 1,
          targetType: "product",
          targetId: "1",
          title: "خصم 50% على البروتين",
          subtitle: "أفضل المكملات لزيادة العضلات بأسرع وقت",
          imageUrl: "https://images.unsplash.com/photo-1579722820308-d74e571900a9?q=80&w=2070&auto=format&fit=crop",
          buttonText: "تسوق الآن",
          hexBackgroundColor: "#1E1E1E",
        ),
        const PromoModel(
          id: 2,
          targetType: "category",
          targetId: "2",
          title: "تخفيضات العيد الرياضية",
          subtitle: "معدات رياضية بأقل الأسعار لفترة محدودة",
          imageUrl: "https://images.unsplash.com/photo-1540497077202-7c8a3999166f?q=80&w=2070&auto=format&fit=crop",
          buttonText: "اكتشف العروض",
          hexBackgroundColor: "#8B0000",
        ),
        const PromoModel(
          id: 3,
          targetType: "web",
          targetId: "https://www.google.com",
          title: "وصل حديثاً",
          subtitle: "مكملات غذائيه صممت خصيصا لتعزيز ادائك",
          imageUrl: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2070&auto=format&fit=crop",
          buttonText: "تصفح التشكيلة",
          hexBackgroundColor: "#0D47A1",
        ),
        const PromoModel(
          id: 4,
          targetType: "web",
          targetId: "https://www.google.com",
          title: "وصل حديثاً",
          subtitle: "مكملات غذائيه صممت خصيصا لتعزيز ادائك",
          imageUrl: "https://eg.bigramylabs.com/cdn/shop/files/Desktop--AR--Ramdan.png",
          buttonText: "تصفح التشكيلة",
          hexBackgroundColor: "#0D47A1",
        ),
        const PromoModel(
          id: 5,
          targetType: "web",
          targetId: "https://www.google.com",
          imageUrl: "https://eg.bigramylabs.com/cdn/shop/files/Best-seller-_-AR.png",
          buttonText: "تصفح التشكيلة",
          hexBackgroundColor: "#0D47A1",
        ),
      ];

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
    state = index % promos.length;
  }

  void onPromoPressed(BuildContext context, PromoModel promo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("عرض ترويجي: ${promo.title ?? 'بدون عنوان'}")),
    );
  }
}
