import 'package:go_router/go_router.dart';
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
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthView(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) =>
            SignInPage(onSignUpTap: () => context.go(AppRoutes.signUp)),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) =>
            SignUpPage(onSignInTap: () => context.go(AppRoutes.signIn)),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartView(),
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ProductModel) {
            return ProductDetailsView(product: extra);
          } else if (extra is Map<String, dynamic>) {
            return ProductDetailsView(
              product: extra['product'] as ProductModel,
              initialFlavor: extra['selectedFlavor'] as String?,
              initialSize: extra['selectedSize'] as String?,
            );
          }
          return const ProductDetailsView();
        },
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        builder: (context, state) => const WishlistView(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const ProductSearchsPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutView(),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        builder: (context, state) => const OrderSuccessView(),
      ),
      GoRoute(
        path: AppRoutes.editUserInfo,
        builder: (context, state) => const EditUserInfoView(),
      ),
      GoRoute(
        path: AppRoutes.orderView,
        builder: (context, state) => const OrderView(),
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
