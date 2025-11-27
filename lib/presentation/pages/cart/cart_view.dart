import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/main_controller.dart';
import 'package:stronger_muscles/presentation/widgets/cart_item_card.dart';

class CartView extends GetView<CartController> {
  // Constants for styling
  static const double _emptyIconSize = 96.0;
  static const double _emptyIconSpacing = 16.0;
  static const double _emptyTextSpacing = 8.0;
  static const double _emptyTitleFontSize = 20.0;
  static const double _emptySubtitleFontSize = 14.0;
  static const double _listTopSpacing = 10.0;
  static const double _checkoutHorizontalPadding = 16.0;
  static const double _checkoutVerticalPadding = 12.0;
  static const double _totalLabelFontSize = 14.0;
  static const double _totalPriceFontSize = 24.0;
  static const double _itemCountFontSize = 12.0;
  static const double _checkoutButtonPadding = 32.0;
  static const double _checkoutButtonVerticalPadding = 16.0;
  static const double _checkoutButtonRadius = 12.0;
  static const double _checkoutButtonFontSize = 18.0;
  static const double _spacing = 12.0;
  static const double _smallSpacing = 4.0;

  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyState(context, theme);
        }
        return _buildCartContent(theme);
      }),
    );
  }

  /// Builds the app bar with item count
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Obx(
        () => Text(
          controller.cartItems.isEmpty
              ? 'Cart'
              : 'Cart (${controller.cartItems.length})',
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
    final controller = Get.find<MainController>();
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
              'Your cart is empty',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: _emptyTitleFontSize,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: _emptyTextSpacing),
            Text(
              'Add products to get started',
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
              label: const Text('Start Shopping'),
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
              return CartItemCard(item: item, controller: controller);
            },
          ),
        ),

        // Divider
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant,
        ),

        // Checkout section
        _buildCheckoutSection(theme),
      ],
    );
  }

  /// Builds the checkout section with total and checkout button
  Widget _buildCheckoutSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _checkoutHorizontalPadding,
        vertical: _checkoutVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Total price section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: _totalLabelFontSize,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            '${controller.cartItems.length} ${controller.cartItems.length == 1 ? 'item' : 'items'}',
                            style: TextStyle(
                              fontSize: _itemCountFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _smallSpacing),
                  Obx(
                    () => Text(
                      '\$${controller.totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: _totalPriceFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: _spacing),

            // Checkout button
            Semantics(
              label: 'Proceed to checkout',
              button: true,
              child: ElevatedButton(
                onPressed: controller.cartItems.isEmpty
                    ? null
                    : () => _handleCheckout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                  disabledForegroundColor:
                      theme.colorScheme.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(
                    horizontal: _checkoutButtonPadding,
                    vertical: _checkoutButtonVerticalPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_checkoutButtonRadius),
                  ),
                  elevation: 2.0,
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: _checkoutButtonFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the checkout action
  void _handleCheckout() {
    // TODO: Implement payment/checkout flow
    Get.snackbar(
      'Checkout',
      'Checkout flow not implemented yet',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16.0),
      borderRadius: 8.0,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
    );
  }
}
