import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_highlight_text.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

class TitleAndDescription extends StatelessWidget {
  const TitleAndDescription({super.key, required this.product, this.query});

  final dynamic product;
  final String? query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    String name = '';
    String description = '';

    if (product is ProductEntity) {
      name = (product as ProductEntity).getLocalizedName(locale: locale);
      description =
          (product as ProductEntity).getLocalizedDescription(locale: locale);
    } else if (product is ProductModel) {
      name = (product as ProductModel).getLocalizedName(locale: locale);
      description =
          (product as ProductModel).getLocalizedDescription(locale: locale);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HighlightText(
          text: name,
          query: query ?? "",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          description,
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
