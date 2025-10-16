import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/productList.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/promoBanner.dart';
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

  Padding searchBar(ThemeData theme) {
    return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Search',
                                ),
                                onChanged: controller.onSearchChanged,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              );
  }



}
