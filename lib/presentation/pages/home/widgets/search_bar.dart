import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

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

  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<HomeController>();


  

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
                    Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: _iconSpacing),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: AppLocalizations.of(context)!.searchProducts,
                        ),
                        onChanged: controller.searchController.onSearchChanged,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
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
                    _showFilterBottomSheet(context, controller);
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

  void _showFilterBottomSheet(BuildContext context, HomeController controller) {
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
                    final min = controller.searchController.dataMinPrice.value;
                    final max = controller.searchController.dataMaxPrice.value;

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
                    return _PriceFilterSlider(controller: controller);
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

class _PriceFilterSlider extends StatefulWidget {
  final HomeController controller;

  const _PriceFilterSlider({required this.controller});

  @override
  State<_PriceFilterSlider> createState() => _PriceFilterSliderState();
}

class _PriceFilterSliderState extends State<_PriceFilterSlider> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
      widget.controller.searchController.filterMinPrice.value,
      widget.controller.searchController.filterMaxPrice.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final minData = widget.controller.searchController.dataMinPrice.value;
    final maxData = widget.controller.searchController.dataMaxPrice.value;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${_currentRangeValues.start.toStringAsFixed(0)}'),
            Text('\$${_currentRangeValues.end.toStringAsFixed(0)}'),
          ],
        ),
        RangeSlider(
          values: _currentRangeValues,
          min: minData,
          max: maxData,
          divisions: (maxData - minData) > 0 ? (maxData - minData).toInt() : 1,
          labels: RangeLabels(
            '\$${_currentRangeValues.start.toStringAsFixed(0)}',
            '\$${_currentRangeValues.end.toStringAsFixed(0)}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              widget.controller.searchController.applyPriceFilter(
                _currentRangeValues.start,
                _currentRangeValues.end,
              );
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ),
      ],
    );
  }

  /// Legacy function for backward compatibility.
  ///
  /// **Deprecated**: Use [SearchBar] widget instead.
  @Deprecated('Use SearchBar widget instead')
  Padding searchBar() {
    final controller = Get.find<HomeController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Search',
                          ),
                          onChanged: controller.searchController.onSearchChanged,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
