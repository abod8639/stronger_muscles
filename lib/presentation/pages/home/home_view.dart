import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/promoBanner.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/sectionTitle.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/shortcutsRow.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';

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
                Padding(
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
                ),

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

  Obx productList(ThemeData theme) {
    return Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                      ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return GestureDetector(
                      onTap: () =>
                          Get.to(() => ProductDetailsView(product: product)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6.0),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: product.id,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    '${product.price.toStringAsFixed(0)}% cashback',
                                    style: TextStyle(
                                      color:
                                          theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
  }



}
