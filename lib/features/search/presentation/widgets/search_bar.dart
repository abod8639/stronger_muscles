import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/price_filter_slider.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_input_group.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Floating home search bar (search field + filter + notifications).
class SearchBar extends StatelessWidget {
  static const double _searchBarHeight = 48.0;
  static const double _verticalPadding = 12.0;

  const SearchBar({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: _searchBarHeight + _verticalPadding * 2,
      titleSpacing: AppDimens.spacingLg,
      title: Hero(
        tag: 'searchBar',
        child: Material(
          color: Colors.transparent,
          child: SearchInputGroup(),
        ),
      ),
    );
  }
}

/// Opens the product filter sheet (price range).
Future<void> showFilterBottomSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return AppBottomSheetScaffold.show<void>(
    context,
    (_) => AppBottomSheetScaffold(
      icon: Icons.tune_rounded,
      title: l10n.filterProducts,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFieldLabel(l10n.price, padding: const EdgeInsets.only(bottom: AppDimens.spacingMd)),
          const PriceFilterSlider(),
        ],
      ),
    ),
  );
}
