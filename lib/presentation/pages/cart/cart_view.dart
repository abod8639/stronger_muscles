import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/presentation/controllers/main_controller.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/build_cart_content.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class CartView extends GetView<CartController> {

  static const double _emptyIconSize = 96.0;
  static const double _emptyIconSpacing = 16.0;
  static const double _emptyTextSpacing = 8.0;
  static const double _emptyTitleFontSize = 20.0;
  static const double _emptySubtitleFontSize = 14.0;
  static const double _checkoutButtonRadius = 12.0;

  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(CartController());
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(context, theme),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyState(context, theme);
        }
        return buildCartContent();
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      title: Obx(
        () => Text(
          controller.cartItems.isEmpty
              ? l10n.cart
              : '${l10n.cart} (${controller.cartItems.length})',
          style: const TextStyle(color: AppColors.white),
        ),
      ),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: AppColors.white),
      elevation: 2.0,
    );
  }

  /// Builds the empty cart state
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    // جلب MainController فقط عند الحاجة (داخل حالة السلة الفارغة)
    final mainController = Get.find<MainController>();
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: _emptyIconSize,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: _emptyIconSpacing),
            Text(
              l10n.yourCartIsEmpty,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: _emptyTitleFontSize,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: _emptyTextSpacing),
            Text(
              l10n.addProductsToGetStarted,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: _emptySubtitleFontSize,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton.icon(
              onPressed: () {
                // الانتقال إلى التبويب الأول (الرئيسية)
                mainController.tabIndex.value = 0;
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: Text(l10n.startShopping),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_checkoutButtonRadius),
                ),
                elevation: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
