import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/error/error.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/functions/cache_manager.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../cart/cart_feature.dart';
import '../../../profile/profile_feature.dart';
import '../controllers/checkout_controller.dart';
import 'address_selection_card.dart';
import 'checkout_price_summary.dart';
import 'payment_option_card.dart';

Step buildAddressStep(WidgetRef ref, String title) {
  final currentStep = ref.watch(checkoutControllerProvider.select((s) => s.currentStep));
  final addressState = ref.watch(addressControllerProvider);
  final context = ref.context;
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  return Step(
    title: Text(title),
    content: addressState.when(
      data: (addresses) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (addresses.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                l10n.noAddressesFound,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
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
            onPressed: () => showAddressForm(context),
            icon: const Icon(Icons.add_location_alt_outlined, size: 18.0),
            label: Text(l10n.addNewAddress),
            style: OutlinedButton.styleFrom(
              shape: AppRadius.shapeMd,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
          ),
        ],
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
          borderRadius: AppRadius.allMd,
          border: Border.all(
            color: theme.colorScheme.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                error is Failure ? error.toMessage() : error.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              color: theme.colorScheme.error,
              onPressed: () => ref.refresh(addressControllerProvider),
            ),
          ],
        ),
      ),
    ),
    isActive: currentStep >= 0,
    state: currentStep > 0 ? StepState.complete : StepState.editing,
  );
}

Step buildPaymentStep(WidgetRef ref, String title) {
  final currentStep = ref.watch(checkoutControllerProvider.select((s) => s.currentStep));
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
    isActive: currentStep >= 1,
    state: currentStep > 1 ? StepState.complete : StepState.editing,
  );
}

Step buildReviewStep(WidgetRef ref, String title) {
  final currentStep = ref.watch(checkoutControllerProvider.select((s) => s.currentStep));
  final selectedAddress = ref.watch(checkoutControllerProvider.select((s) => s.selectedAddress));
  final selectedPaymentMethod = ref.watch(checkoutControllerProvider.select((s) => s.selectedPaymentMethod));
  final cartState = ref.watch(cartControllerProvider);
  final cartNotifier = ref.watch(cartControllerProvider.notifier);
  final context = ref.context;
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

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
              final imageUrl = item.primaryImageUrl ?? '';
              final effectivePrice = item.product.getEffectivePriceForSize(item.selectedSize);

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
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 20.0,
                                ),
                              ),
                            )
                          : Container(
                              width: 44.0,
                              height: 44.0,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 20.0,
                              ),
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
                            '${item.quantity} x LE ${effectivePrice.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'LE ${item.subtotal.toStringAsFixed(2)}',
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
          error: (error, _) => Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: AppRadius.allMd,
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    error is Failure ? error.toMessage() : error.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  color: theme.colorScheme.error,
                  onPressed: () => ref.refresh(cartControllerProvider),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Divider(color: theme.colorScheme.outlineVariant),
        const SizedBox(height: 4.0),
        CheckoutPriceSummary(cartSubtotal: cartNotifier.totalPrice),
        const SizedBox(height: 16.0),
        if (selectedAddress != null) ...[
          Text(
            l10n.shippingTo,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            selectedAddress.fullAddress,
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
          selectedPaymentMethod == 'cash'
              ? l10n.cashOnDelivery
              : l10n.creditCardOrOnline,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16.0),
        const CheckoutNotesInput(),
      ],
    ),
    isActive: currentStep >= 2,
    state: StepState.editing,
  );
}

/// Lifecycle-managed text field for checkout notes, avoiding memory leaks.
class CheckoutNotesInput extends ConsumerStatefulWidget {
  const CheckoutNotesInput({super.key});

  @override
  ConsumerState<CheckoutNotesInput> createState() => _CheckoutNotesInputState();
}

class _CheckoutNotesInputState extends ConsumerState<CheckoutNotesInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialNotes = ref.read(checkoutControllerProvider).notes;
    _controller = TextEditingController(text: initialNotes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppTextFormField(
      label: l10n.notes,
      hintText: l10n.enterAdditionalNotes,
      controller: _controller,
      maxLines: 3,
      onChanged: (val) {
        ref.read(checkoutControllerProvider.notifier).setNotes(val);
      },
    );
  }
}
