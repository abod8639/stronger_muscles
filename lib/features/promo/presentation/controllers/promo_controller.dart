import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';
import 'package:stronger_muscles/features/promo/data/repositories/promo_repository_impl.dart';
import 'package:stronger_muscles/routes/routes.dart';

part 'promo_controller.g.dart';

@riverpod
Future<List<PromoModel>> promos(PromosRef ref) {
  return ref.watch(promoRepositoryProvider).getPromos();
}

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

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!pageController.hasClients) return;
      
      final promosAsync = ref.read(promosProvider);
      if (promosAsync.value == null || promosAsync.value!.isEmpty) return;

      int nextPage = pageController.page!.round() + 1;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void updateCurrentIndex(int index, int length) {
    if (length == 0) return;
    state = index % length;
  }

  /// Handles promo banner tap — navigates based on [PromoModel.targetType].
  Future<void> onPromoPressed(BuildContext context, PromoModel promo) async {
    if (promo.targetType != 'product' || promo.targetId == null) return;

    try {
      final product = await ref
          .read(productRepositoryProvider.notifier)
          .getProductById(promo.targetId!);

      if (context.mounted) {
        context.push(AppRoutes.productDetails, extra: product);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر تحميل تفاصيل المنتج')),
        );
      }
    }
  }
}
