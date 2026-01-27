import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';

const double _cardMarginHorizontal = 16.0;
const double _cardPadding = 20.0;
const double _cardBorderRadius = 16.0;
const double _dividerHeight = 50.0;
const double _dividerWidth = 1.0;
const double _dividerOpacity = 0.3;
const double _iconSize = 28.0;
const double _valueFont = 22.0;
const double _labelFont = 12.0;
const double _valueIconSpacing = 8.0;
const double _valueLabelSpacing = 4.0;
const double _shadowOpacity = 0.3;
const double _shadowBlurRadius = 12.0;
const double _shadowOffsetY = 4.0;

class PurchaseStatsCard extends StatelessWidget {
  const PurchaseStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: _cardMarginHorizontal),
        padding: const EdgeInsets.all(_cardPadding),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(_shadowOpacity),
              blurRadius: _shadowBlurRadius,
              offset: const Offset(0, _shadowOffsetY),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Total Spent',
              'LE ${controller.totalSpent.toStringAsFixed(0)}',
              Icons.payments_outlined,
            ),
            Container(
              height: _dividerHeight,
              width: _dividerWidth,
              color: AppColors.white.withOpacity(_dividerOpacity),
            ),
            _buildStatItem(
              'Completed',
              '${controller.deliveredOrders}',
              Icons.check_circle_outline,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: _iconSize),
        const SizedBox(height: _valueIconSpacing),
        Text(
          value,
          style: const TextStyle(
            fontSize: _valueFont,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: _valueLabelSpacing),
        Text(
          label,
          style: TextStyle(
            fontSize: _labelFont,
            color: AppColors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
