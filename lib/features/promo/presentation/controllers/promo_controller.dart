import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';
import 'package:stronger_muscles/features/promo/promo_providers.dart';
import 'package:stronger_muscles/features/search/search_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

part 'promo_controller.g.dart';

@riverpod
Future<List<PromoEntity>> promos(PromosRef ref) async {
  final result = await ref.watch(getPromosUseCaseProvider).call();
  return result.fold(
    (failure) => throw failure,
    (promos) => promos,
  );
}

@riverpod
class PromoController extends _$PromoController {
  Timer? _timer;
  late final PageController pageController;
  final int initialPage = 10000;
  bool _isHandlingTap = false;

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

      final nextPage = pageController.page!.round() + 1;
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

  /// Handles promo banner tap with guard clauses against duplicate actions (Rule 4).
  Future<void> onPromoPressed(BuildContext context, PromoEntity promo) async {
    if (_isHandlingTap) return;
    if (promo.targetId == null) return;

    _isHandlingTap = true;
    try {
      if (promo.targetType == 'product') {
        final result = await ref
            .read(getProductByIdUseCaseProvider)
            .call(promo.targetId!);

        result.fold(
          (failure) {
            if (context.mounted) {
              final l10n = AppLocalizations.of(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n?.unableToLoadProductDetails ??
                        'Unable to load product details',
                  ),
                ),
              );
            }
          },
          (product) {
            if (context.mounted) {
              context.push(AppRoutes.productDetails, extra: product);
            }
          },
        );
        return;
      }

      if (promo.targetType == 'brand') {
        final brandName = promo.targetId!;
        ref
            .read(productSearchControllerProvider.notifier)
            .updateSearchQuery(brandName);
        if (context.mounted) {
          context.push(AppRoutes.search);
        }
        return;
      }
    } finally {
      _isHandlingTap = false;
    }
  }
}
