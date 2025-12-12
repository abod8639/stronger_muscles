import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/main_controller.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/buildCheckoutSection.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/cart_item_card.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/checkoutButton.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class CartView extends GetView<CartController> {
  // Constants for styling
  static const double _emptyIconSize = 96.0;
  static const double _emptyIconSpacing = 16.0;
  static const double _emptyTextSpacing = 8.0;
  static const double _emptyTitleFontSize = 20.0;
  static const double _emptySubtitleFontSize = 14.0;
  static const double _listTopSpacing = 10.0;
  static const double _checkoutButtonRadius = 12.0;
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyState(theme);
        }
        return _buildCartContent(theme);
      }),
    );
  }

  /// Builds the app bar with item count
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Obx(
        () => Text(
          controller.cartItems.isEmpty
              ? AppLocalizations.of(context)!.cart
              : '${AppLocalizations.of(context)!.cart} (${controller.cartItems.length})',
          style: const TextStyle(color: AppColors.white),
        ),
      ),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: AppColors.white),
      elevation: 2.0,
    );
  }

  /// Builds the empty cart state
  Widget _buildEmptyState(ThemeData theme) {
    final controller = Get.find<MainController>();
    return Builder(
      builder: (context) {
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
                  AppLocalizations.of(context)!.yourCartIsEmpty,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: _emptyTitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: _emptyTextSpacing),
                Text(
                  AppLocalizations.of(context)!.addProductsToGetStarted,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: _emptySubtitleFontSize,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.tabIndex.value = 0;
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(AppLocalizations.of(context)!.startShopping),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        _checkoutButtonRadius,
                      ),
                    ),
                    elevation: 2.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the cart content with items and checkout section
  Widget _buildCartContent(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: _listTopSpacing),

        // Cart items list
        Expanded(
          child: ListView.builder(
            itemCount: controller.cartItems.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = controller.cartItems[index];
              return CartItemCard(item: item);
            },
          ),
        ),

        // Divider
        Divider(height: 1, color: theme.colorScheme.outlineVariant),

        // Checkout section
        buildCheckoutSection(),
      ],
    );
  }
  /// Handles the checkout action

}
