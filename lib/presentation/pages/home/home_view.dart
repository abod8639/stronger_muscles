import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/bindings/sections_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/search_bar.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/shortcuts_row.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/promo_banner.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/section_title.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_list.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
        final sectionsController = Get.put(SectionsController());

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // await controller.fetchProducts();
          },
          child: SingleChildScrollView(
            child: Obx(
              ()=> Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Search bar and filter button
                  searchBar(),
              
                  // Shortcuts row
                  SelectionsRow(),
              
                  // Promo banner
                  sectionsController.selectedIndex.value == 0 ? 
                  promoBanner() : SizedBox.shrink(),
                 
                  // Section title
                  sectionTitle(),
              
                  // Horizontal product list
                  productList(),
              
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
