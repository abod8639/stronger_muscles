import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/main_controller.dart';

BottomNavigationBar myBottomNavigationBar(ThemeData theme) {
  final controller = Get.put(MainController());

  return BottomNavigationBar(
    currentIndex: controller.tabIndex.value,
    onTap: controller.changeTabIndex,
    type: BottomNavigationBarType.fixed,
    backgroundColor:
        theme.bottomNavigationBarTheme.backgroundColor ??
        theme.colorScheme.surface,
    selectedItemColor:
        theme.bottomNavigationBarTheme.selectedItemColor ??
        theme.colorScheme.primary,
    unselectedItemColor:
        theme.bottomNavigationBarTheme.unselectedItemColor ??
        theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
    showUnselectedLabels: true,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
  );
}
