import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/shortcuts_row.dart';
import 'package:stronger_muscles/features/promo/presentation/widgets/promo_banner.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/section_title.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/product_list.dart';

class HomeView extends ConsumerWidget {
  static const double _bottomPadding = 20.0;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsState = ref.watch(categoriesSectionsControllerProvider);
    final selectedCategoryIndex = ref.watch(categoriesSectionsControllerProvider.notifier).selectedIndex;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: RefreshIndicator(
              onRefresh: () =>
                  AppGuard.runSafeInternet(ref, () => ref.read(homeControllerProvider.notifier).refreshHome()),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  const SearchBar(),
                  const SliverToBoxAdapter(child: CategoriesShortcutsRow()),
                  if (selectedCategoryIndex == 0)
                    const SliverToBoxAdapter(child: PromoBanner()),
                  const SliverToBoxAdapter(child: SectionTitle()),
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
