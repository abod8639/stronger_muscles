import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Display label and icon for each FAQ category (single source for chips and badges).
extension FaqCategoryUi on FaqCategory {
  String label(AppLocalizations? l10n) => switch (this) {
        FaqCategory.all => l10n?.allCategories ?? 'الكل',
        FaqCategory.ordersShipping => l10n?.categoryOrdersShipping ?? 'الطلبات والتوصيل',
        FaqCategory.supplements => l10n?.categorySupplements ?? 'المكملات والجودة',
        FaqCategory.paymentRefunds => l10n?.categoryPaymentRefunds ?? 'الدفع والاسترجاع',
        FaqCategory.accountGeneral => l10n?.categoryAccountGeneral ?? 'الحساب والاستشارات',
      };

  IconData get icon => switch (this) {
        FaqCategory.all => Icons.auto_awesome_rounded,
        FaqCategory.ordersShipping => Icons.local_shipping_outlined,
        FaqCategory.supplements => Icons.fitness_center_rounded,
        FaqCategory.paymentRefunds => Icons.account_balance_wallet_outlined,
        FaqCategory.accountGeneral => Icons.health_and_safety_outlined,
      };
}

/// Badge color for a canonical ticket status
/// (`open`, `in_progress`, `waiting_user`, `resolved`, `closed`).
Color ticketStatusColor(String status) => switch (status) {
      'open' => AppColors.warning,
      'in_progress' => AppColors.info,
      'waiting_user' => Colors.deepPurple,
      'resolved' => AppColors.success,
      _ => AppColors.grey,
    };

/// Badge color for a support ticket's status.
extension SupportTicketUi on SupportTicketEntity {
  Color get statusColor => ticketStatusColor(status);
}
