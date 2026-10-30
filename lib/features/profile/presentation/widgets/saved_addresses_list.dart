import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/address_card.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/profile_skeleton.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/show_address_form.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Saved delivery addresses with an "Add new" action.
class SavedAddressesList extends ConsumerWidget {
  const SavedAddressesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesState = ref.watch(addressControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: l10n.savedAddresses,
          actionText: l10n.addNew,
          onActionTap: () => showAddressForm(context),
        ),
        addressesState.when(
          data: (addresses) => addresses.isEmpty
              ? AppEmptyState(
                  fillHeight: false,
                  icon: Icons.location_off_outlined,
                  title: l10n.noAddressesSavedYet,
                  actionText: l10n.addNewAddress,
                  actionIcon: Icons.add_location_alt_outlined,
                  onActionTap: () => showAddressForm(context),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spacingXl,
                    vertical: AppDimens.spacingLg,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
                  child: Column(
                    children: [
                      for (final (index, address) in addresses.indexed) ...[
                        if (index > 0) const SizedBox(height: AppDimens.spacingLg),
                        AddressCard(address: address),
                      ],
                    ],
                  ),
                ),
          loading: () => const AddressesListSkeleton(),
          error: (error, _) => AppAlertCard(
            color: AppColors.error,
            icon: AppErrorCard.iconFor(error),
            message: AppErrorCard.messageFor(error, l10n),
            margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
            actionLabel: l10n.retry,
            onAction: ref.read(addressControllerProvider.notifier).fetchAddresses,
          ),
        ),
      ],
    );
  }
}
