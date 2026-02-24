import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class TitleAndDescription extends StatelessWidget {
  const TitleAndDescription({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.getLocalizedName(locale: locale),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: product.getLocalizedName(locale: locale),
        ),
        const SizedBox(height: 4.0),
        Text(
          product.getLocalizedDescription(locale: locale),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
