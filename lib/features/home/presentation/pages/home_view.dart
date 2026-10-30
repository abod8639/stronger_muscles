import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/search/search_feature.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/shortcuts_row.dart';
import 'package:stronger_muscles/features/promo/promo_feature.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/product_list.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class HomeView extends ConsumerWidget {
  static const double _maxContentWidth = 1200.0;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAllSelected = ref.watch(selectedCategoryIndexProvider) == 0;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => AppGuard.runSafeInternet(
                ref,
                () => ref.read(homeControllerProvider.notifier).refreshHome(),
              ),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  const SearchBar(),
                  const SliverToBoxAdapter(child: CategoriesShortcutsRow()),
                  if (isAllSelected) ...[
                    const SliverToBoxAdapter(child: PromoBanner()),
                    SliverToBoxAdapter(
                      child: AppSectionTitle(
                        title: l10n?.mostPopularOffers ?? 'الأكثر طلباً والعروض',
                        actionText: l10n?.seeAll ?? 'عرض الكل',
                        onActionTap: () => context.push(AppRoutes.products),
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.spacingLg,
                          AppDimens.spacingMd,
                          AppDimens.spacingSm,
                          AppDimens.spacingSm,
                        ),
                      ),
                    ),
                  ],
                  const ProductList(),
                  const SliverToBoxAdapter(child: SizedBox(height: AppDimens.spacingLg + 4)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
