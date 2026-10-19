import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Clean Architecture widget for selecting a shipping address during checkout.
class AddressSelectionCard extends ConsumerWidget {
  final AddressEntity address;

  const AddressSelectionCard({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutControllerProvider);
    final l10n = AppLocalizations.of(context);

    return AppSelectableCard<AddressEntity>(
      value: address,
      groupValue: checkoutState.selectedAddress,
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
