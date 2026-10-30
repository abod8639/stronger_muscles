import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Single source for how an order's status and payment are displayed
/// (badge label/color, tracker step) across the order screens.
extension OrderStatusUi on OrderEntity {
  String get _status => status.toLowerCase();

  bool get isCancelled => _status == 'cancelled' || _status == 'canceled';

  /// Index in the tracker steps: pending → processing → shipped → delivered.
  int get statusStep => switch (_status) {
        'processing' => 1,
        'shipped' => 2,
        'delivered' => 3,
        _ => 0,
      };

  Color get statusColor => switch (_status) {
        'pending' => AppColors.warning,
        'processing' => AppColors.primary,
        'shipped' => AppColors.info,
        'delivered' => AppColors.success,
        'cancelled' || 'canceled' => AppColors.error,
        _ => AppColors.greyDark,
      };

  String statusLabel(AppLocalizations l10n) => switch (_status) {
        'pending' => l10n.pending,
        'processing' => l10n.processing,
        'shipped' => l10n.shipped,
        'delivered' => l10n.delivered,
        'cancelled' || 'canceled' => l10n.cancelled,
        _ => status.toUpperCase(),
      };

  String paymentMethodLabel(AppLocalizations l10n) => switch (paymentMethod.toLowerCase()) {
        'cash' => l10n.cashOnDelivery,
        'card' => l10n.creditCardOrOnline,
        _ => paymentMethod.toUpperCase(),
      };

  /// Short id for list cards, e.g. `#a1b2c3`.
  String get shortId => '#${id.length > 6 ? id.substring(0, 6) : id}';
}
