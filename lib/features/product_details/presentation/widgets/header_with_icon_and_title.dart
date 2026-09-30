import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class HeaderWithIconandTitle extends StatelessWidget {
  const HeaderWithIconandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: .1),
            AppColors.primary.withValues(alpha: .05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: .15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .15),
              borderRadius: AppDimens.borderRadiusSm,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: AppDimens.iconSm,
            ),
          ),

          const SizedBox(width: 12),

          Text(
            AppLocalizations.of(context)!.productDescription,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
