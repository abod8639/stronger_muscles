import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/main_controller.dart';
import 'package:stronger_muscles/presentation/pages/auth/signup_page.dart';
import 'package:stronger_muscles/presentation/pages/cart/cart_view.dart';
import 'package:stronger_muscles/presentation/pages/home/home_view.dart';
import 'package:stronger_muscles/presentation/pages/profile/profile_page.dart';
import 'package:stronger_muscles/presentation/pages/wishlist/wishlist_view.dart';
import 'package:stronger_muscles/presentation/widgets/my_bottom_navigation_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    final pages = 
    <Widget>[
      const HomeView(),
      const WishlistView(),
      const CartView(),
      const ProfilePage(),
      // const  SignInPage(),
      const SignUpPage()
      // const AuthView()
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: pages),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
