import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget buildStatusTracker(bool isDark, bool isAr, OrderEntity order) {
  return Builder(
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      final theme = Theme.of(context);
      final statusLower = order.status.toLowerCase();
      final isCancelled = statusLower == 'cancelled' || statusLower == 'canceled';

      final steps = [
        l10n.pending,
        l10n.processing,
        l10n.shipped,
        l10n.delivered,
      ];

      int activeIndex = 0;
      switch (statusLower) {
        case 'pending':
          activeIndex = 0;
          break;
        case 'processing':
          activeIndex = 1;
          break;
        case 'shipped':
          activeIndex = 2;
          break;
        case 'delivered':
          activeIndex = 3;
          break;
        default:
          activeIndex = 0;
          break;
      }

      return AppCard(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.orderTracking,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            AppStepProgress(
              steps: steps,
              activeIndex: activeIndex,
              isCancelled: isCancelled,
              cancelledLabel: l10n.orderCancelled,
            ),
          ],
        ),
      );
    },
  );
}
