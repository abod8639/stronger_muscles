
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/product_search_autocomplete.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

const double _spacing = 10.0;

class SearchInputGroup extends ConsumerWidget {
  const SearchInputGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(productSearchControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Row(
      children: [
        Expanded(
          child: ProductSearchAutocomplete(
            readOnly: true,
            autofocus: false,
            onTap: () {
              ref.read(productSearchControllerProvider.notifier).clearSearch();
              context.push(
                AppRoutes.search, extra: controller.searchQuery);
            },
          ),
        ),
        const SizedBox(width: _spacing),
        buildFilterButton(
          controller: controller,
          l10n: l10n,
          onTap: () {
            ref.read(productSearchControllerProvider.notifier).clearSearch();
            context.push(AppRoutes.search, extra: controller.searchQuery);
          },
        ),
        const SizedBox(width: _spacing),
        Container(
          width: 48.0,
          height: 48.0,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            boxShadow: AppDimens.subtleShadow(
              theme.colorScheme.onSurfaceVariant,
            ),
          ),
          child: IconButton(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.notifications_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onPressed: () => context.push(AppRoutes.notifications),
            tooltip: l10n.notifications,
          ),
        ),
      ],
    );
  }
}
