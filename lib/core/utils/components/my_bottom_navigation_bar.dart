import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/main_controller.dart';

class MyBottomNavigationBar extends ConsumerWidget {
  static const double _elevation = 8.0;
  static const double _iconSize = 24.0;
  static const double _selectedFontSize = 12.0;
  static const double _unselectedFontSize = 11.0;
  static const double _unselectedOpacity = 0.6;

  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tabIndex = ref.watch(mainControllerProvider);
    final cartState = ref.watch(cartControllerProvider);

    return BottomNavigationBar(
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      currentIndex: tabIndex,
      onTap: (index) => ref.read(mainControllerProvider.notifier).changeTabIndex(index),
      type: BottomNavigationBarType.fixed,
      elevation: _elevation,
      backgroundColor:
          theme.bottomNavigationBarTheme.backgroundColor ??
          theme.colorScheme.surface,
      selectedItemColor:
          theme.bottomNavigationBarTheme.selectedItemColor ??
          theme.colorScheme.primary,
      unselectedItemColor:
          theme.bottomNavigationBarTheme.unselectedItemColor ??
          theme.colorScheme.onSurface.withValues(alpha: _unselectedOpacity),
      selectedFontSize: _selectedFontSize,
      unselectedFontSize: _unselectedFontSize,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      enableFeedback: true,
      items: _buildNavigationItems(tabIndex, cartState.value?.length ?? 0),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems(
    int currentIndex,
    int cartCount,
  ) {
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
        icon: Badge(
          isLabelVisible: cartCount > 0,
          label: Text('$cartCount'),
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          child: Icon(
            currentIndex == 2
                ? Icons.shopping_cart
                : Icons.shopping_cart_outlined,
            size: _iconSize,
          ),
        ),
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
