import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/main_controller.dart';
import 'package:stronger_muscles/presentation/widgets/cartIcon.dart';

/// A custom bottom navigation bar widget for the main app navigation.
/// 
/// This widget provides navigation between Home, Wishlist, Cart, and Profile screens.
/// It uses GetX for state management and reactive updates.
class MyBottomNavigationBar extends StatelessWidget {
  // Constants for styling
  static const double _elevation = 8.0;
  static const double _iconSize = 24.0;
  static const double _selectedFontSize = 12.0;
  static const double _unselectedFontSize = 11.0;
  static const double _unselectedOpacity = 0.6;

  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<MainController>();
    final cartController = Get.put(CartController());

    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.tabIndex.value,
        onTap: controller.changeTabIndex,
        type: BottomNavigationBarType.fixed,
        elevation: _elevation,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
            theme.colorScheme.surface,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor ??
            theme.colorScheme.primary,
        unselectedItemColor:
            theme.bottomNavigationBarTheme.unselectedItemColor ??
                theme.colorScheme.onSurface
                    .withValues(alpha: _unselectedOpacity),
        selectedFontSize: _selectedFontSize,
        unselectedFontSize: _unselectedFontSize,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        enableFeedback: true,
        items: _buildNavigationItems(controller.tabIndex.value, cartController),
      ),
    );
  }

  /// Builds the navigation items with dynamic icons based on selection state.
  List<BottomNavigationBarItem> _buildNavigationItems(
      int currentIndex, CartController cartController) {
    return [
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 0 ? Icons.home : Icons.home_outlined,
          size: _iconSize,
        ),
        label: 'Home',
        tooltip: 'Navigate to Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 1 ? Icons.favorite : Icons.favorite_outline,
          size: _iconSize,
        ),
        label: 'Wishlist',
        tooltip: 'Navigate to Wishlist',
      ),
      BottomNavigationBarItem(
        icon: Obx(() {
          final count = cartController.cartItems.length;
          return Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            child: Icon(
              currentIndex == 2
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined,
              size: _iconSize,
            ),
          );
        }),
        label: 'Cart',
        tooltip: 'Navigate to Cart',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 3 ? Icons.person : Icons.person_outline,
          size: _iconSize,
        ),
        label: 'Profile',
        tooltip: 'Navigate to Profile',
      ),
    ];
  }
}

/// Legacy function for backward compatibility.
/// 
/// **Deprecated**: Use [MyBottomNavigationBar] widget instead.
@Deprecated('Use MyBottomNavigationBar widget instead')
BottomNavigationBar myBottomNavigationBar(ThemeData theme) {
  final controller = Get.put(MainController());

  return BottomNavigationBar(
    currentIndex: controller.tabIndex.value,
    onTap: controller.changeTabIndex,
    type: BottomNavigationBarType.fixed,
    backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
        theme.colorScheme.surface,
    selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor ??
        theme.colorScheme.primary,
    unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.6),
    showUnselectedLabels: true,
    items:  [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
      BottomNavigationBarItem(icon: cartIcon() , label: 'Cart'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
  );
}


