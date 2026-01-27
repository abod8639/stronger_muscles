import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/controllers/profile_controller.dart';

const double _rowSpacing = 12.0;
const double _cardPadding = 16.0;
const double _cardBorderRadius = 12.0;
const double _iconSize = 28.0;
const double _valueFont = 20.0;
const double _labelFont = 12.0;
const double _labelSpacing = 8.0;
const double _valueSpacing = 4.0;
const double _shadowOpacity = 0.05;
const double _shadowBlurRadius = 8.0;

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.shopping_bag_outlined,
              label: 'Orders',
              value: controller.totalOrders.toString(),
              color: AppColors.primary,
              onTap: () {},
            ),
          ),
          const SizedBox(width: _rowSpacing),
          Expanded(
            child: Obx(
              () => _buildQuickActionCard(
                icon: Icons.favorite_outline,
                label: 'Wishlist',
                value: controller.wishlistCount.value.toString(),
                color: AppColors.error,
                onTap: () => Get.toNamed('/wishlist'),
              ),
            ),
          ),
          const SizedBox(width: _rowSpacing),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.location_on_outlined,
              label: 'Addresses',
              value: controller.addresses.length.toString(),
              color: AppColors.success,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          child: Container(
            padding: const EdgeInsets.all(_cardPadding),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.white,
              borderRadius: BorderRadius.circular(_cardBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(_shadowOpacity),
                  blurRadius: _shadowBlurRadius,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: _iconSize),
                const SizedBox(height: _labelSpacing),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: _valueFont,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: _valueSpacing),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: _labelFont,
                    color: AppColors.greyDark,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
