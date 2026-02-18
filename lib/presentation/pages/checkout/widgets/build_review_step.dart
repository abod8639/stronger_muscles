import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/presentation/controllers/checkout_controller.dart';

Step buildReviewStep(String title) {
  final checkoutController = Get.find<CheckoutController>();
  final cartController = Get.find<CartController>();

  return Step(
    title: Text(title),
    content: Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              addRepaintBoundaries: true,
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartController.cartItems[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    cacheManager: CustomCacheManager.instance,
                    imageUrl: item.product.imageUrls.first,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    memCacheWidth: 50,
                    memCacheHeight: 50,
                    errorWidget: (_, _, _) => const Icon(Icons.image),
                  ),
                  title: Text(item.product.name),
                  subtitle: Text(
                    '${item.quantity} x LE ${item.product.effectivePrice}',
                  ),
                  trailing: Text(
                    'LE ${(item.product.effectivePrice * item.quantity).toStringAsFixed(2)}',
                  ),
                );
              },
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'LE ${cartController.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (checkoutController.selectedAddress.value != null) ...[
              const Text(
                'Shipping To:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(checkoutController.selectedAddress.value!.fullAddress),
            ],
            const SizedBox(height: 8),
            const Text(
              'Payment Method:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              checkoutController.selectedPaymentMethod.value == 'cod'
                  ? 'Cash on Delivery'
                  : 'Credit Card',
            ),
            const SizedBox(height: 8),
            // notes
            const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            TextField(
              controller: cartController.notesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter any additional notes',
              ),
            ),
          ],
        );
      },
    ),
    isActive: checkoutController.currentStep.value >= 2,
    state: StepState.editing,
  );
}
