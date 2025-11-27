import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';

class QuickActionsRow extends StatelessWidget {
  final ProfileController controller;
  final ThemeData theme;

  const QuickActionsRow({
    super.key,
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => _buildQuickActionCard(
              icon: Icons.favorite_outline,
              label: 'Wishlist',
              value: controller.wishlistCount.value.toString(),
              color: AppColors.error,
              onTap: () => Get.toNamed('/wishlist'),
            )),
          ),
          const SizedBox(width: 12),
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
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.greyDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
