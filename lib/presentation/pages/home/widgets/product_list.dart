import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_container.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';

Widget productList(ThemeData theme) {
  final controller = Get.find<HomeController>();
  return Obx(() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          return GestureDetector(
            onTap: () => Get.to(() => ProductDetailsView(product: product)),
            child: ProductContainer(
              showName: true,
              height: 180,
              product: product,
              theme: theme,
            ),
          );
        },
      ),
    );
  });
}



    //

