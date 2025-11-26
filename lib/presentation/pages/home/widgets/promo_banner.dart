import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';

/// Promotional banner widget displayed on the home page
class PromoBanner extends StatelessWidget {
  // Constants for styling
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _bannerHeight = 141.0;
  static const double _borderRadius = 16.0;
  static const double _contentPadding = 16.0;
  static const double _titleSpacing = 8.0;
  static const double _buttonSpacing = 12.0;
  static const double _buttonHeight = 36.0;
  static const double _buttonBorderRadius = 20.0;
  static const double _iconSize = 72.0;
  static const double _iconPadding = 12.0;

  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      child: Container(
        height: _bannerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            // Banner content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(_contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Special Offer!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: _titleSpacing),

                    // Subtitle
                    Text(
                      'Get 20% off on all products',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: _buttonSpacing),

                    // Action button
                    SizedBox(
                      height: _buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement promo action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_buttonBorderRadius),
                          ),
                          elevation: 2.0,
                        ),
                        child: const Text('Shop Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Icon
            Padding(
              padding: const EdgeInsets.only(right: _iconPadding),
              child: Icon(
                Icons.local_offer_outlined,
                size: _iconSize,
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Legacy function for backward compatibility.
/// 
/// **Deprecated**: Use [PromoBanner] widget instead.
@Deprecated('Use PromoBanner widget instead')
Padding promoBanner() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.secondaryContainer,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Shop with 100% cashback',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text('On Shopee', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 12.0),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'I want!',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Icon(
                  Icons.sports_gymnastics_sharp,
                  size: 72,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
