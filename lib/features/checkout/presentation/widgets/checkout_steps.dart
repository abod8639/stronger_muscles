import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/core/utils/functions/show_address_form.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/build_payment_option.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Step buildAddressStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final addresses = ref.watch(addressControllerProvider).value ?? [];
  final l10n = AppLocalizations.of(ref.context)!;

  return Step(
    title: Text(title),
    content: Column(
      children: [
        if (addresses.isEmpty)
          Text(l10n.noAddressesFound)
        else
          Column(
            children: addresses.map((address) {
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
                    address.label ?? l10n.error,
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
          label: Text(l10n.addNewAddress),
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
  final l10n = AppLocalizations.of(ref.context)!;

  return Step(
    title: Text(title),
    content: Column(
      children: [
        buildPaymentOption(
          ref: ref,
          value: 'cash',
          title: l10n.cashOnDelivery,
          icon: Icons.money,
        ),
        const SizedBox(height: 8),
        buildPaymentOption(
          ref: ref,
          value: 'card',
          title: l10n.creditCardOrOnline,
          icon: Icons.credit_card,
          subtitle: l10n.paySecurelyStripe,
          enabled: true,
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
  final checkoutNotifier = ref.read(checkoutControllerProvider.notifier);
  final cartState = ref.watch(cartControllerProvider);
  final cartNotifier = ref.watch(cartControllerProvider.notifier);
  final l10n = AppLocalizations.of(ref.context)!;

  return Step(
    title: Text(title),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.orderSummary,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                title: Text(item.product.getLocalizedName(locale: l10n.localeName)),
                subtitle: Text(
                  '${item.quantity} x ${l10n.currency} ${item.product.baseEffectivePrice}',
                ),
                trailing: Text(
                  '${l10n.currency} ${(item.product.baseEffectivePrice * item.quantity).toStringAsFixed(2)}',
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('${l10n.error}: $e'),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.totalAmount,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${l10n.currency} ${cartNotifier.totalPrice.toStringAsFixed(2)}',
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
          Text(
            l10n.shippingTo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(checkoutState.selectedAddress!.fullAddress),
        ],
        const SizedBox(height: 8),
        Text(
          l10n.paymentMethod,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          checkoutState.selectedPaymentMethod == 'cash'
              ? l10n.cashOnDelivery
              : l10n.creditCardOrOnline,
        ),
        const SizedBox(height: 16),
        Text(l10n.notes, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: checkoutState.notes,
          onChanged: (val) => checkoutNotifier.setNotes(val),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: l10n.enterAdditionalNotes,
          ),
        ),
      ],
    ),
    isActive: checkoutState.currentStep >= 2,
    state: StepState.editing,
  );
}
