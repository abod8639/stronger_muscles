import 'package:get/get.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_binding.dart';
import 'package:stronger_muscles/presentation/bindings/home_binding.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_binding.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/order_binding.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_binding.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_binding.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_binding.dart';
import 'package:stronger_muscles/presentation/bindings/checkout_binding.dart';
import 'package:stronger_muscles/presentation/bindings/main_binding.dart';

import 'package:stronger_muscles/features/auth/presentation/pages/auth_view.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signin_page.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signup_page.dart';
import 'package:stronger_muscles/features/cart/presentation/pages/cart_view.dart';
import 'package:stronger_muscles/features/home/presentation/pages/home_view.dart';
import 'package:stronger_muscles/main_page.dart';
import 'package:stronger_muscles/features/order/presentation/pages/order_view.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/edit_user_info.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/profile_page.dart';
import 'package:stronger_muscles/presentation/pages/wishlist/wishlist_view.dart';
import 'package:stronger_muscles/presentation/pages/checkout/checkout_view.dart';
import 'package:stronger_muscles/presentation/pages/checkout/order_success_view.dart';

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
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order_success';
  static const String editUserInfo = '/edit_user_info';
  static const String orderView = '/order_view';
  static const String orderDetails = '/order_details';
}

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => SignInPage(onSignUpTap: () => Get.offNamed(AppRoutes.signUp)),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignUpPage(onSignInTap: () => Get.offNamed(AppRoutes.signIn)),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessView(),
      binding: OrderBinding(),
    ),

    GetPage(
      name: AppRoutes.editUserInfo,
      page: () => const EditUserInfoView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.orderView,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.orderDetails,
    //   page: () => const OrderDetailsView(),
    //   binding: OrderDetailsBinding(),
    // ),
  ];
}
