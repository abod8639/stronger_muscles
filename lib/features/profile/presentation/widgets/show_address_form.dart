import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/address_form.dart';

void showAddressForm(BuildContext context, {AddressEntity? address}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: AppDimens.borderRadiusBottomSheet,
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AddressForm(address: address),
    ),
  );
}
