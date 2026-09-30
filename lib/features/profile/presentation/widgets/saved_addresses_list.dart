import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/section_title.dart';
import 'package:stronger_muscles/core/utils/functions/show_address_form.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/address_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class SavedAddressesList extends ConsumerWidget {
  const SavedAddressesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final addressesState = ref.watch(addressControllerProvider);
    final intl10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: intl10n.savedAddresses,
          actionWidget: OutlinedButton.icon(
            onPressed: () => showAddressForm(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: .5),
                width: 1.5,
              ),
              backgroundColor: AppColors.primary.withValues(alpha: .05),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spacingMd,
                vertical: AppDimens.spacingSm,
              ),
              shape: const StadiumBorder(),
            ),
            icon: const Icon(Icons.add_rounded, size: AppDimens.iconSm),
            label: Text(
              intl10n.addNew,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        addressesState.when(
          data: (addresses) => addresses.isEmpty
              ? _buildEmptyState(theme, intl10n)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  addRepaintBoundaries: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spacingLg,
                    vertical: AppDimens.spacingSm,
                  ),
                  itemCount: addresses.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppDimens.spacingLg),
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressCard(address: address);
                  },
                ),
          loading: () => const Padding(
            padding: EdgeInsets.all(AppDimens.spacingXl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Center(child: Text('${intl10n.error}: $e')),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations intl10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Text(
              intl10n.noAddressesSavedYet,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
