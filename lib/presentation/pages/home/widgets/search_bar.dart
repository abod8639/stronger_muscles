import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
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
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Search products...',
                      ),
                      onChanged: controller.onSearchChanged,
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
            label: 'Filter products',
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
                  // TODO: Implement filter functionality
                },
                tooltip: 'Filter',
              ),
            ),
          ),
        ],
      ),
    );
  }
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
                        onChanged: controller.onSearchChanged,
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
