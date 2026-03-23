import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_input_group.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/price_filter_slider.dart';

const double _horizontalPadding = 16.0;
const double _verticalPadding = 12.0;
const double _searchBarHeight = 48.0;
const double _iconButtonSize = 48.0;


class SearchBar extends StatelessWidget {
  const SearchBar({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: _searchBarHeight + _verticalPadding * 2,
      titleSpacing: _horizontalPadding,
      title: const Hero(
        tag: 'searchBar',
        child: Material(
          color: Colors.transparent,
          child: SearchInputGroup(),
        ),
      ),
    );
  }
}

Widget buildFilterButton({
  required ProductSearchController controller,
  required AppLocalizations l10n,
  Function()? onTap,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Container(
        width: _iconButtonSize,
        height: _iconButtonSize,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.tune, color: theme.colorScheme.onSurfaceVariant),
          onPressed: onTap,
          tooltip: l10n.filter,
        ),
      );
    },
  );
}

void showFilterBottomSheet(BuildContext context, AppLocalizations l10n) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildHandle(context)),
            const SizedBox(height: 24),
            Text(
              l10n.filterProducts,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.priceOnRequest
                  .replaceAll("on request", '')
                  .replaceAll("عند الطلب", ''),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const PriceFilterSlider(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  );
}

Widget _buildHandle(BuildContext context) => Container(
  width: 40,
  height: 4,
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.outlineVariant,
    borderRadius: BorderRadius.circular(2),
  ),
);
