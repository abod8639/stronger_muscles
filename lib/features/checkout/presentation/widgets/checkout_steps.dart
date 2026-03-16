import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/core/utils/functions/show_address_form.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/build_payment_option.dart';

Step buildAddressStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final profileNotifier = ref.watch(profileControllerProvider.notifier);

  return Step(
    title: Text(title),
    content: Column(
      children: [
        if (profileNotifier.addresses.isEmpty)
          const Text('No addresses found. Please add one in your profile.')
        else
          Column(
            children: profileNotifier.addresses.map((address) {
              final bool isSelected =
                  checkoutState.selectedAddress?.id == address.id;
              return Card(
                elevation: isSelected ? 2 : 0,
                color: isSelected
                    ? AppColors.primary.withValues(alpha: .05)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                  ),
                ),
                child: RadioListTile(
                  value: address,
                  groupValue: checkoutState.selectedAddress,
                  onChanged: (value) => ref
                      .read(checkoutControllerProvider.notifier)
                      .setAddress(value!),
                  title: Text(
                    address.label ?? "error",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(address.fullAddress),
                  activeColor: AppColors.primary,
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => showAddressForm(ref.context),
          icon: const Icon(Icons.add),
          label: const Text('Add New Address'),
        ),
      ],
    ),
    isActive: checkoutState.currentStep >= 0,
    state: checkoutState.currentStep > 0
        ? StepState.complete
        : StepState.editing,
  );
}

Step buildPaymentStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  return Step(
    title: Text(title),
    content: Column(
      children: [
        buildPaymentOption(
          ref: ref,
          value: 'cash',
          title: 'Cash on Delivery',
          icon: Icons.money,
        ),
        const SizedBox(height: 8),
        buildPaymentOption(
          ref: ref,
          value: 'card',
          title: 'Credit Card',
          icon: Icons.credit_card,
          subtitle: 'Coming soon',
          enabled: false,
        ),
      ],
    ),
    isActive: checkoutState.currentStep >= 1,
    state: checkoutState.currentStep > 1
        ? StepState.complete
        : StepState.editing,
  );
}

Step buildReviewStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final cartState = ref.watch(cartControllerProvider);
  final cartNotifier = ref.watch(cartControllerProvider.notifier);

  return Step(
    title: Text(title),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        cartState.when(
          data: (items) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: CachedNetworkImage(
                  cacheManager: CustomCacheManager.instance,
                  imageUrl: item.product.imageUrls.isNotEmpty
                      ? item.product.imageUrls.first.thumbnail
                      : '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const Icon(Icons.image),
                ),
                title: Text(item.product.getLocalizedName(locale: 'en')),
                subtitle: Text(
                  '${item.quantity} x LE ${item.product.baseEffectivePrice}',
                ),
                trailing: Text(
                  'LE ${(item.product.baseEffectivePrice * item.quantity).toStringAsFixed(2)}',
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
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
              'LE ${cartNotifier.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (checkoutState.selectedAddress != null) ...[
          const Text(
            'Shipping To:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(checkoutState.selectedAddress!.fullAddress),
        ],
        const SizedBox(height: 8),
        const Text(
          'Payment Method:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          checkoutState.selectedPaymentMethod == 'cash'
              ? 'Cash on Delivery'
              : 'Credit Card',
        ),
        const SizedBox(height: 16),
        const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: cartNotifier.notesController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter any additional notes',
          ),
        ),
      ],
    ),
    isActive: checkoutState.currentStep >= 2,
    state: StepState.editing,
  );
}
