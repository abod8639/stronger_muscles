import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/main_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/pages/cart_view.dart';
import 'package:stronger_muscles/features/home/presentation/pages/home_view.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/profile_page.dart';
import 'package:stronger_muscles/features/wishlist/presentation/pages/wishlist_view.dart';
import 'package:stronger_muscles/core/utils/components/my_bottom_navigation_bar.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeView(),
      const WishlistView(),
      const CartView(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.tabIndex.value,
                children: pages,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
