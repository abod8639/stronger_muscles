import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/bindings/sections_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/search_bar.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/shortcuts_row.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/promo_banner.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/section_title.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_list.dart';

class HomeView extends GetView<HomeController> {
  // Constants for spacing
  static const double _bottomPadding = 20.0;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionsController = Get.put(SectionsController());

    return Scaffold(
      // drawer: const Drawer(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshHome();
                await Get.find<SectionsController>().fetchCategories();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Search bar and filter button
                  const SearchBar(),
                   
            
                  // Category shortcuts row
                  const SliverToBoxAdapter(child: ShortcutsRow()),
            
                  // Promo banner (only shown for "All" category)
                  Obx(
                    () => sectionsController.selectedIndex.value == 0
                        ? const SliverToBoxAdapter(child: PromoBanner())
                        : const SliverToBoxAdapter(child: SizedBox.shrink()),
                  ),
            
                  // Section title
                  const SliverToBoxAdapter(child: SectionTitle()),
            
                  // Product grid
                  const ProductList(),
            
                  const SliverToBoxAdapter(child: SizedBox(height: _bottomPadding)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
