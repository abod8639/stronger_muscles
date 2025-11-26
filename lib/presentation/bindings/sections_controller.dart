// Sections controller 

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/selection_model.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';

class SectionsController extends GetxController {
  final HomeController _homeController = Get.find<HomeController>();

  final RxInt selectedIndex = 0.obs;

  final List<Selections> selections = [
    Selections(label: 'Home', icon: Icons.home),
    Selections(label: 'Protein', icon: Icons.fitness_center),
    Selections(label: 'Creatine', icon: Icons.sports_handball),
    Selections(label: 'Amino', icon: Icons.local_drink),
    Selections(label: 'BCAA', icon: Icons.bolt),
    Selections(label: 'Pre-workout', icon: Icons.flash_on),
    Selections(label: 'Mass Gainer', icon: Icons.sports_martial_arts),
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