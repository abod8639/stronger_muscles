import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
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
    final textTheme = context.textTheme;
    final title = promo.title;
    final subtitle = promo.subtitle;
    final hasText = (title?.isNotEmpty ?? false) || (subtitle?.isNotEmpty ?? false);

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      padding: EdgeInsets.zero,
      color: promo.backgroundColor,
      borderRadius: AppRadius.allLg,
      boxShadow: AppShadows.banner(context.theme.shadowColor),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(
            imageUrl: promo.imageUrl,
            borderRadius: BorderRadius.zero,
            backgroundColor: promo.backgroundColor,
            showLoadingIndicator: false,
            errorIcon: Icons.local_offer_outlined,
          ),
          if (hasText)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.1),
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
                if (title != null && title.isNotEmpty)
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.spacingXs),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
                  ),
                ],
                if (promo.targetId != null) ...[
                  const SizedBox(height: AppDimens.spacingMd),
                  AppBadge(
                    label: promo.buttonText,
                    icon: Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.white,
                    border: Border.all(color: Colors.transparent, width: 0),
                    borderRadius: AppRadius.allPill,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacingLg,
                      vertical: AppDimens.spacingSm,
                    ),
                    textStyle: textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
