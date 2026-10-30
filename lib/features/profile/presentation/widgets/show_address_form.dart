import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/address_form.dart';

/// Opens the add/edit address sheet.
Future<void> showAddressForm(BuildContext context, {AddressEntity? address}) =>
    AppBottomSheetScaffold.show<void>(context, (_) => AddressForm(address: address));
