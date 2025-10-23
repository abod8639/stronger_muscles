// Sections controller 

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/shortcuts_row.dart';

class SectionsController extends GetxController {

  final RxInt selectedIndex = 0.obs;

      final List<Selections> selections = [
      Selections(
        onTap: () {},
        label: 'Home', icon: Icons.home),
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