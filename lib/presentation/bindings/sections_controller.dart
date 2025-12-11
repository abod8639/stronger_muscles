// Sections controller 

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/selection_model.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';

class SectionsController extends GetxController {
  final HomeController _homeController = Get.put(HomeController());

  final RxInt selectedIndex = 0.obs;

  final List<Selections> selections = [
    Selections(label: 'categoryHome', icon: Icons.home),
    Selections(label: 'categoryProtein', icon: Icons.fitness_center),
    Selections(label: 'categoryCreatine', icon: Icons.sports_handball),
    Selections(label: 'categoryAmino', icon: Icons.local_drink),
    Selections(label: 'categoryBCAA', icon: Icons.bolt),
    Selections(label: 'categoryPreWorkout', icon: Icons.flash_on),
    Selections(label: 'categoryMassGainer', icon: Icons.sports_martial_arts),
  ];

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in homeController's selected index
    ever(_homeController.selectedSectionIndex, (index) {
      selectedIndex.value = index;
    });
  }

  void updateIndex(int index) {
    _homeController.fetchProductsForSection(index);
  }
}