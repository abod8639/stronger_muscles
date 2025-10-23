import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_container.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/shortcuts_row.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';

Obx productList(ThemeData theme) {
  final controller = Get.find<HomeController>();
  return Obx(() {
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

// Sections controller 

class SectionsController extends GetxController {
  var selectedIndex = 0.obs;

      final List<Selections> selections = [
      Selections(
        onTap: () {},
        label: 'Protein', icon: Icons.fitness_center),
      Selections(
        onTap: () {},
        label: 'Creatine', icon: Icons.sports_handball),
      Selections(
        onTap: () {},
        label: 'Amino', icon: Icons.local_drink),
      Selections(
        onTap: () {},
        label: 'BCAA', icon: Icons.bolt),
      Selections(
        onTap: () {},
        label: 'Pre-workout', icon: Icons.flash_on),
      Selections(
        onTap: () {},
        label: 'Mass Gainer', icon: Icons.sports_martial_arts),
    ];


  void updateIndex(int index) {
    selectedIndex.value = index;
  }


}