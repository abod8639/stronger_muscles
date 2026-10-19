import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/core/utils/functions/show_address_form.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/address_selection_card.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/payment_option_card.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Step buildAddressStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final addresses = ref.watch(addressControllerProvider).value ?? [];
  final l10n = AppLocalizations.of(ref.context)!;

  return Step(
    title: Text(title),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (addresses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              l10n.noAddressesFound,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(ref.context).colorScheme.onSurfaceVariant),
            ),
          )
        else
          Column(
            children: addresses.map((address) {
              return AddressSelectionCard(address: address);
            }).toList(),
          ),
        const SizedBox(height: 12.0),
        OutlinedButton.icon(
          onPressed: () => showAddressForm(ref.context),
          icon: const Icon(Icons.add_location_alt_outlined, size: 18.0),
          label: Text(l10n.addNewAddress),
          style: OutlinedButton.styleFrom(
            shape: AppRadius.shapeMd,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
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
        PaymentOptionCard(
          value: 'cash',
          title: l10n.cashOnDelivery,
          icon: Icons.payments_outlined,
        ),
        const SizedBox(height: 8.0),
        PaymentOptionCard(
          value: 'card',
          title: l10n.creditCardOrOnline,
          icon: Icons.credit_card_outlined,
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
  final theme = Theme.of(ref.context);

  return Step(
    title: Text(title),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.orderSummary,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        cartState.when(
          data: (items) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => Divider(
              height: 1.0,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              final imageUrl = item.primaryImageUrl ??
                  (item.product.imageUrls.isNotEmpty
                      ? item.product.imageUrls.first.thumbnail
                      : '');

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.allSm,
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              cacheManager: CustomCacheManager.instance,
                              imageUrl: imageUrl,
                              width: 44.0,
                              height: 44.0,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) => Container(
                                width: 44.0,
                                height: 44.0,
                                color: theme.colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.image_not_supported_outlined, size: 20.0),
                              ),
                            )
                          : Container(
                              width: 44.0,
                              height: 44.0,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.image_not_supported_outlined, size: 20.0),
                            ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.getLocalizedName(locale: l10n.localeName),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            '${item.quantity} x LE ${item.product.baseEffectivePrice.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'LE ${(item.product.baseEffectivePrice * item.quantity).toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Text('${l10n.error}: $e'),
        ),
        const SizedBox(height: 8.0),
        Divider(color: theme.colorScheme.outlineVariant),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.totalAmount,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'LE ${cartNotifier.totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        if (checkoutState.selectedAddress != null) ...[
          Text(
            l10n.shippingTo,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            checkoutState.selectedAddress!.fullAddress,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12.0),
        ],
        Text(
          l10n.paymentMethod,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          checkoutState.selectedPaymentMethod == 'cash'
              ? l10n.cashOnDelivery
              : l10n.creditCardOrOnline,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16.0),
        AppTextFormField(
          label: l10n.notes,
          hintText: l10n.enterAdditionalNotes,
          controller: TextEditingController(text: checkoutState.notes)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: checkoutState.notes.length),
            ),
          maxLines: 3,
          onChanged: (val) => checkoutNotifier.setNotes(val),
        ),
      ],
    ),
    isActive: checkoutState.currentStep >= 2,
    state: StepState.editing,
  );
}
