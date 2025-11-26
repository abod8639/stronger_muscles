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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh functionality
            // await controller.fetchProducts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar and filter button
                  const SearchBar(),

                  // Category shortcuts row
                  const ShortcutsRow(),

                  // Promo banner (only shown for "All" category)
                  if (sectionsController.selectedIndex.value == 0)
                    const PromoBanner(),

                  // Section title
                  const SectionTitle(),

                  // Product grid
                  const ProductList(),

                  const SizedBox(height: _bottomPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
