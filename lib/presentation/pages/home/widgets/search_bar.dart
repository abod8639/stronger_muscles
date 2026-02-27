import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/price_filter_slider.dart';

class SearchBar extends StatelessWidget {
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 12.0;
  static const double _searchBarHeight = 48.0;
  static const double _borderRadius = 24.0;
  static const double _iconButtonSize = 48.0;
  static const double _spacing = 12.0;

  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchController = Get.find<ProductSearchController>();
    final l10n = AppLocalizations.of(context)!;

    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: _searchBarHeight + _verticalPadding * 2,
      titleSpacing: _horizontalPadding,
      title: Row(
        children: [
          Expanded(child: _buildSearchField(theme, searchController, l10n)),
          const SizedBox(width: _spacing),

          _buildFilterButton(context, theme, searchController, l10n),
        ],
      ),
    );
  }

  Widget _buildSearchField(
    ThemeData theme,
    ProductSearchController controller,
    AppLocalizations l10n,
  ) {
    return Container(
      height: _searchBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: controller.textController,
              onChanged: controller.onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration.collapsed(
                hintText: l10n.searchProducts,
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 20),
                onPressed: controller.clearSearch,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    ThemeData theme,
    ProductSearchController controller,
    AppLocalizations l10n,
  ) {
    return Container(
      width: _iconButtonSize,
      height: _iconButtonSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.tune, color: theme.colorScheme.onSurfaceVariant),
        onPressed: () => _showFilterBottomSheet(context, controller, l10n),
        tooltip: l10n.filter,
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    ProductSearchController searchController,
    AppLocalizations l10n,
  ) {
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
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildHandle(context)),
                const SizedBox(height: 24),
                Text(
                  l10n.filterProducts,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Price Range', // TODO: Localize
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                const PriceFilterSlider(),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Apply Filter'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
