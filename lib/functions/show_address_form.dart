
import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/address_form.dart';

void showAddressForm(BuildContext context, {AddressModel? address}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AddressForm(address: address),
    ),
  );
}
