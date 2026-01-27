import 'package:flutter/material.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

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
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.mostPopularOffers,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement see all functionality
            },
            child: Text(AppLocalizations.of(context)!.seeAll),
          ),
        ],
      ),
    );
  }
}
