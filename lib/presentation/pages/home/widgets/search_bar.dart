import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/price_filter_slider.dart';

/// Custom search bar widget with filter button for the home page
class SearchBar extends StatelessWidget {
  // Constants for styling
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 12.0;
  static const double _searchBarHeight = 48.0;
  static const double _borderRadius = 24.0;
  static const double _iconButtonSize = 48.0;
  static const double _spacing = 12.0;
  static const double _innerPadding = 12.0;
  static const double _iconSpacing = 8.0;
  // static const Duration _debounceDelay = Duration(milliseconds: 300);

  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<HomeController>();
    final searchController = Get.find<ProductSearchController>();


    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: _searchBarHeight + _verticalPadding * 2,
      titleSpacing: _horizontalPadding,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
        child: Row(
          children: [
            // Search input field
            Expanded(
              child: Container(
                height: _searchBarHeight,
                padding: const EdgeInsets.symmetric(horizontal: _innerPadding),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: _iconSpacing),
                    Expanded(
                      child: TextField(
                        controller: searchController.textController,
                        decoration: InputDecoration.collapsed(
                          hintText: AppLocalizations.of(
                            context,
                          )!.searchProducts,
                        ),
                        onChanged: searchController.onSearchChanged,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    Obx(() {
                      if (searchController.isLoadingRemote.value) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      if (
                          searchController
                          .searchQuery
                          .value
                          .isNotEmpty) {
                        return IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            searchController..clearSearch();
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(width: _spacing),

            // Filter button
            Semantics(
              label: AppLocalizations.of(context)!.filterProducts,
              button: true,
              child: Container(
                width: _iconButtonSize,
                height: _iconButtonSize,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _showFilterBottomSheet(context, controller, searchController);
                  },
                  tooltip: AppLocalizations.of(context)!.filter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, HomeController controller, ProductSearchController searchController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.filterProducts,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Price Range', // TODO: Add to AppLocalizations if possible, strictly using hardcoded for now as I can't edit arb files easily
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final min = searchController.dataMinPrice.value;
                    final max = searchController.dataMaxPrice.value;

                    // Ensure valid range
                    if (min >= max) {
                      return const Center(
                        child: Text('Price filtering unavailable'),
                      );
                    }

                    // Local state for the slider within Obx is tricky,
                    // ideally we should use a StatefulBuilder for the sheet content
                    // to handle slider dragging smoothly without committing to controller immediately.
                    // But we can just use controller values for now if we want live update,
                    // or better: use StatefulBuilder.
                    return PriceFilterSlider();
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

}
