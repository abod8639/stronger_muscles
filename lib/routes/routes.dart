import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/pages/auth/auth_view.dart';
import 'package:stronger_muscles/presentation/pages/auth/signin_page.dart';
import 'package:stronger_muscles/presentation/pages/auth/signup_page.dart';
import 'package:stronger_muscles/presentation/pages/cart/cart_view.dart';
import 'package:stronger_muscles/presentation/pages/home/home_view.dart';
import 'package:stronger_muscles/presentation/pages/main_page.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';
import 'package:stronger_muscles/presentation/pages/profile/profile_page.dart';
import 'package:stronger_muscles/presentation/pages/wishlist/wishlist_view.dart';

class AppRoutes {
  static const String main = '/';
  static const String auth = '/auth';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String productDetails = '/product_details';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
}

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => SignInPage(
        onSignUpTap: () => Get.offNamed(AppRoutes.signUp),
      ),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignUpPage(
        onSignInTap: () => Get.offNamed(AppRoutes.signIn),
      ),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () {
        // Expecting product to be passed as arguments
        return ProductDetailsView(product: Get.arguments);
      },
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistView(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
    ),
  ];
}
