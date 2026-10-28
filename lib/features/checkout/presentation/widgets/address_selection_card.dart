import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../profile/profile_feature.dart';
import '../controllers/checkout_controller.dart';

/// Clean Architecture widget for selecting a shipping address during checkout.
class AddressSelectionCard extends ConsumerWidget {
  const AddressSelectionCard({
    super.key,
    required this.address,
  });

  final AddressEntity address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAddress = ref.watch(
      checkoutControllerProvider.select((s) => s.selectedAddress),
    );
    final l10n = AppLocalizations.of(context);

    return AppSelectableCard<AddressEntity>(
      value: address,
      groupValue: selectedAddress,
      onChanged: (val) {
        if (val != null) {
          ref.read(checkoutControllerProvider.notifier).setAddress(val);
        }
      },
      title: address.label ?? l10n?.address ?? '',
      subtitle: address.fullAddress,
      leadingIcon: Icons.location_on_outlined,
    );
  }
}
