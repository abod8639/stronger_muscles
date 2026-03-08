import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
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
        const SizedBox(height: 12),
        // Dots Indicator
        Obx(() {
          if (controller.promos.isEmpty) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.promos.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 4,
                width: controller.currentIndex.value == index ? 15 : 5,
                decoration: BoxDecoration(
                  color: controller.currentIndex.value == index
                      ? AppColors.primary
                      : AppColors.greyMedium,
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
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(
              promo.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: promo.backgroundColor),
            ),
            // Gradient Overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.2),
                  ],
                  // Default Directionality is RTL in Arabic apps usually,
                  // but we set strong gradient on the start to match text.
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
                    promo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promo.subtitle,
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
