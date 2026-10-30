import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/product_search_autocomplete.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Search page header: live autocomplete field + filter button.
class SearchBarInline extends StatelessWidget {
  static const double _height = 48.0;

  final bool isFocused;
  const SearchBarInline({super.key, required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Row(
        children: [
          Expanded(child: ProductSearchAutocomplete(autofocus: isFocused)),
          const SizedBox(width: AppDimens.spacingMd),
          AppCircleIconButton(
            icon: Icons.tune_rounded,
            tooltip: AppLocalizations.of(context)!.filter,
            onPressed: () => showFilterBottomSheet(context),
          ),
        ],
      ),
    );
  }
}
