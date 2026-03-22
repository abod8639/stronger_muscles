import 'package:flutter/material.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

AppBar baseAppBar(BuildContext context, AppLocalizations localizations) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        localizations.cart,
        style: Theme.of(context).textTheme.titleLarge,
      ),
     centerTitle: true,
     );
  }