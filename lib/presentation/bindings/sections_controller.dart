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
    Selections(label: 'categoryAmino', icon: Icons.local_drink),
    Selections(label: 'categoryVitamins', icon: Icons.medication),
    Selections(label: 'categoryPreWorkout', icon: Icons.flash_on),
    Selections(label: 'categoryRecovery', icon: Icons.healing),
    Selections(label: 'categoryFatBurner', icon: Icons.local_fire_department),
    Selections(label: 'categoryHealth', icon: Icons.favorite),
  ];

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in homeController's selected index
    ever<int>(_homeController.selectedSectionIndex, (index) {
      selectedIndex.value = index;
    });
  }

  void updateIndex(int index) {
    _homeController.fetchProductsForSection(index);
  }
}