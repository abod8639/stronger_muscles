import 'package:flutter/material.dart';

/// Section title widget with "See all" button
class SectionTitle extends StatelessWidget {
  // Constants for styling
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;

  const SectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Most Popular Offers',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement see all functionality
            },
            child: const Text('See all'),
          ),
        ],
      ),
    );
  }
}

/// Legacy function for backward compatibility.
/// 
/// **Deprecated**: Use [SectionTitle] widget instead.
@Deprecated('Use SectionTitle widget instead')
Padding sectionTitle() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Most popular offer',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('See all')),
          ],
        );
      },
    ),
  );
}
