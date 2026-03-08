import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/promo_model.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';
import 'package:stronger_muscles/presentation/controllers/add_controller.dart';

class PromoBanner extends GetView<AddController> {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Obx(() {
            if (controller.promos.isEmpty) {
              return const SizedBox.shrink();
            }
            return PageView.builder(
              pageSnapping: false,
              controller: controller.pageController,
              onPageChanged: controller.updateCurrentIndex,
              itemBuilder: (context, index) {
                final promo =
                    controller.promos[index % controller.promos.length];
                return _buildPromoCard(promo);
              },
            );
          }),
        ),
        const SizedBox(height: 8),
        // Dots Indicator
        Obx(() {
          if (controller.promos.isEmpty) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.promos.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: controller.currentIndex.value == index ? 15 : 5,
                decoration: BoxDecoration(
                  color: controller.currentIndex.value == index
                      ? AppColors.primary
                      : AppColors.greyDark,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPromoCard(PromoModel promo) {
    return GestureDetector(
      onTap: () => controller.onPromoPressed(promo),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: promo.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
              blurStyle: BlurStyle.outer
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: promo.imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) =>
                  Container(color: promo.backgroundColor),
            ),
            // Gradient Overlay for text readability
        if (promo.title != null)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                ),
              ),
            ),
            // Text Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    promo.title ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promo.subtitle ?? "",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      promo.buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
