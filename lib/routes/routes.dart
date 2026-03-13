import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
// import 'package:get/get.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_binding.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_binding.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_binding.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/order_binding.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_binding.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_binding.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_binding.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/main_binding.dart';

import 'package:stronger_muscles/features/auth/presentation/pages/auth_view.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signin_page.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signup_page.dart';
import 'package:stronger_muscles/features/cart/presentation/pages/cart_view.dart';
import 'package:stronger_muscles/features/home/presentation/pages/home_view.dart';
import 'package:stronger_muscles/main_page.dart';
import 'package:stronger_muscles/features/order/presentation/pages/order_view.dart';
import 'package:stronger_muscles/features/product_details/presentation/pages/product_details_view.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/edit_user_info.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/profile_page.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/order/presentation/pages/order_details_view.dart';
import 'package:stronger_muscles/features/wishlist/presentation/pages/wishlist_view.dart';
import 'package:stronger_muscles/features/search/presentation/pages/searchs_page.dart';
import 'package:stronger_muscles/features/checkout/presentation/pages/checkout_view.dart';
import 'package:stronger_muscles/features/checkout/presentation/pages/order_success_view.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';

class AppRoutes {
  static const String main = '/';
  static const String auth = '/auth';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String productDetails = '/product_details';
  static const String wishlist = '/wishlist';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order_success';
  static const String editUserInfo = '/edit_user_info';
  static const String orderView = '/order_view';
  static const String orderDetails = '/order_details';
}

class AppPages {
  static final router = GoRouter(
    initialLocation: AppRoutes.main,
    routes: [
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) {
          MainBinding().dependencies();
          return const MainPage();
        },
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) {
          AuthBinding().dependencies();
          return const AuthView();
        },
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) {
          AuthBinding().dependencies();
          return SignInPage(
            onSignUpTap: () => context.go(AppRoutes.signUp),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) {
          AuthBinding().dependencies();
          return SignUpPage(
            onSignInTap: () => context.go(AppRoutes.signIn),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          HomeBinding().dependencies();
          return const HomeView();
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) {
          CartBinding().dependencies();
          return const CartView();
        },
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (context, state) {
          final product = state.extra;
          if (product is ProductModel) {
            Get.replace<ProductDetailsController>(ProductDetailsController(product));
          } else if (product is Map<String, dynamic>) {
            final p = product['product'] as ProductModel;
            final flavor = product['selectedFlavor'] as String?;
            final size = product['selectedSize'] as String?;
            Get.replace<ProductDetailsController>(ProductDetailsController(p, initialFlavor: flavor, initialSize: size));
          }
          return const ProductDetailsView();
        },
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        builder: (context, state) {
          WishlistBinding().dependencies();
          return const WishlistView();
        },
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) {
          // If we need to pass data to search, we can use Get.put or something
          return const ProductSearchsPage();
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) {
          ProfileBinding().dependencies();
          return const ProfilePage();
        },
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) {
          CheckoutBinding().dependencies();
          return const CheckoutView();
        },
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        builder: (context, state) {
          OrderBinding().dependencies();
          return const OrderSuccessView();
        },
      ),
      GoRoute(
        path: AppRoutes.editUserInfo,
        builder: (context, state) {
          ProfileBinding().dependencies();
          return const EditUserInfoView();
        },
      ),
      GoRoute(
        path: AppRoutes.orderView,
        builder: (context, state) {
          OrderBinding().dependencies();
          return const OrderView();
        },
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return OrderDetailsView(order: order);
        },
      ),
    ],
  );
}
