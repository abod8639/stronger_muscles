import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/profile/profile_providers.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Brand-gradient summary of total spent and completed orders.
class PurchaseStatsCard extends ConsumerWidget {
  const PurchaseStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(profileStatsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      padding: const EdgeInsets.all(AppDimens.spacingXl),
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDark],
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
      ),
      boxShadow: AppShadows.colored(AppColors.primary),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              label: l10n.totalSpent,
              value: AppPriceText.format(stats.totalSpent, decimals: 0),
              icon: Icons.payments_outlined,
            ),
          ),
          Container(height: 56.0, width: 1.0, color: AppColors.white.withValues(alpha: 0.3)),
          Expanded(
            child: _StatItem(
              label: l10n.completed,
              value: '${stats.deliveredOrders}',
              icon: Icons.check_circle_outline_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppIconTile(
          icon: icon,
          color: AppColors.white,
          backgroundColor: AppColors.white.withValues(alpha: 0.15),
          iconSize: 22.0,
          circular: true,
        ),
        const SizedBox(height: AppDimens.spacingSm),
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
        ),
      ],
    );
  }
}
