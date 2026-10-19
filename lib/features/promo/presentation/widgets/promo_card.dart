import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';

/// Presentation card displaying a single promotional item.
class PromoCard extends StatelessWidget {
  final PromoEntity promo;
  final VoidCallback onTap;

  const PromoCard({
    super.key,
    required this.promo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
        decoration: BoxDecoration(
          borderRadius: AppRadius.allLg,
          color: promo.backgroundColor,
          boxShadow: AppShadows.banner(theme.shadowColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: promo.imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) =>
                  Container(color: promo.backgroundColor),
            ),
            if (promo.title != null)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.2),
                    ],
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.centerEnd,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    promo.title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  Text(
                    promo.subtitle ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.spacingLg),
                  if (promo.targetId != null)
                    AppBadge(
                      label: promo.buttonText,
                      color: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.primary,
                      textColor: Colors.white,
                      border: Border.all(color: Colors.transparent, width: 0),
                      borderRadius: AppRadius.allSm,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spacingLg,
                        vertical: AppDimens.spacingSm,
                      ),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
