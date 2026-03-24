import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/highlight_text.dart';

class TitleAndDescription extends StatelessWidget {
  const TitleAndDescription({super.key, required this.product, this.query});

  final ProductModel product;
  final String? query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HighlightText(
          text: product.getLocalizedName(locale: locale),
          query: query ?? "",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          // show onle 100 char
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
