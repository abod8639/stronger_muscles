import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/shortcuts_row.dart';
import 'package:stronger_muscles/features/promo/presentation/widgets/promo_banner.dart';
import 'package:stronger_muscles/core/utils/components/section_title.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/product_list.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class HomeView extends ConsumerWidget {
  static const double _bottomPadding = 20.0;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryIndex = ref.watch(selectedCategoryIndexProvider);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: RefreshIndicator(
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
                  if (selectedCategoryIndex == 0)
                    const SliverToBoxAdapter(child: PromoBanner()),
                  if (selectedCategoryIndex == 0)
                    SliverToBoxAdapter(
                      child: SectionTitle(
                        title: l10n.mostPopularOffers,
                        actionText: l10n.seeAll,
                        onActionTap: () {
                          // TODO: Implement see all functionality
                        },
                      ),
                    ),
                  const ProductList(),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: _bottomPadding),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
