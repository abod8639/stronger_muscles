import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/notifications/notifications_feature.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/product_search_autocomplete.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Home header row: tap-to-search field, filter shortcut and notifications bell.
class SearchInputGroup extends ConsumerWidget {
  const SearchInputGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    void openSearch() {
      final controller = ref.read(productSearchControllerProvider.notifier);
      controller.clearSearch();
      context.push(AppRoutes.search, extra: controller.searchQuery);
    }

    return Row(
      children: [
        Expanded(child: ProductSearchAutocomplete(readOnly: true, onTap: openSearch)),
        const SizedBox(width: AppDimens.spacingSm + 2),
        AppCircleIconButton(
          icon: Icons.tune_rounded,
          tooltip: l10n.filter,
          onPressed: openSearch,
        ),
        const SizedBox(width: AppDimens.spacingSm + 2),
        AppCircleIconButton(
          icon: Icons.notifications_outlined,
          tooltip: l10n.notifications,
          badgeCount: unreadCount,
          onPressed: () => context.push(AppRoutes.notifications),
        ),
      ],
    );
  }
}
