import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/promo/presentation/controllers/promo_controller.dart';
import 'package:stronger_muscles/features/promo/presentation/widgets/promo_card.dart';

/// Clean Architecture carousel banner for promotional items.
/// Dumb UI widget orchestrating the carousel and its indicator dots.
class PromoBanner extends ConsumerWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promosAsync = ref.watch(promosProvider);

    return promosAsync.when(
      data: (promos) {
        if (promos.isEmpty) return const SizedBox.shrink();

        final promoNotifier = ref.read(promoControllerProvider.notifier);

        return Column(
          children: [
            SizedBox(
              height: 170,
              child: PageView.builder(
                allowImplicitScrolling: false,
                pageSnapping: true,
                controller: promoNotifier.pageController,
                onPageChanged: (index) =>
                    promoNotifier.updateCurrentIndex(index, promos.length),
                itemBuilder: (context, index) {
                  final promo = promos[index % promos.length];
                  return PromoCard(
                    promo: promo,
                    onTap: () => promoNotifier.onPromoPressed(context, promo),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimens.spacingSm),
            _PromoDotsIndicator(itemCount: promos.length),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 170,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

/// Isolated dots indicator widget to prevent rebuilding the PageView on index change.
class _PromoDotsIndicator extends ConsumerWidget {
  final int itemCount;

  const _PromoDotsIndicator({required this.itemCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(promoControllerProvider);
    return AppDotsIndicator(
      itemCount: itemCount,
      currentIndex: currentIndex,
    );
  }
}
