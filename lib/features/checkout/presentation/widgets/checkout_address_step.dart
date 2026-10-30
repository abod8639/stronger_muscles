import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../profile/profile_feature.dart';
import 'address_selection_card.dart';

/// Step 1: pick (or add) the shipping address.
class CheckoutAddressStep extends ConsumerWidget {
  const CheckoutAddressStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final addressState = ref.watch(addressControllerProvider);

    return addressState.when(
      data: (addresses) => addresses.isEmpty
          ? AppEmptyState(
              icon: Icons.location_off_outlined,
              title: l10n.noAddressesFound,
              subtitle: l10n.pleaseSelectShippingAddress,
              actionText: l10n.addNewAddress,
              actionIcon: Icons.add_location_alt_outlined,
              onActionTap: () => showAddressForm(context),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSectionTitle(
                  title: l10n.pleaseSelectShippingAddress,
                  padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
                ),
                for (final address in addresses) AddressSelectionCard(address: address),
                const SizedBox(height: AppDimens.spacingMd),
                AppSocialButton(
                  icon: const Icon(Icons.add_location_alt_outlined, size: AppDimens.iconSm),
                  label: l10n.addNewAddress,
                  onPressed: () => showAddressForm(context),
                ),
              ],
            ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppDimens.spacingXl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => AppErrorCard(
        error: error,
        onRetry: () => ref.invalidate(addressControllerProvider),
      ),
    );
  }
}
