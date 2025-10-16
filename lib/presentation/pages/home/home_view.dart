import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/productList.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/promoBanner.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/searchBar.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/sectionTitle.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/shortcutsRow.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // await controller.fetchProducts();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Search bar and filter button
                searchBar(theme),

                // Shortcuts row
                shortcutsRow(theme),

                // Promo banner
                promoBanner(theme),

                // Section title
                sectionTitle(theme),

                // Horizontal product list
                productList(theme),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }



}
