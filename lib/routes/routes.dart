import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';

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

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.main,
    refreshListenable: AuthRefreshListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoggedIn = authState.value != null;
      
      final isAuthPath = state.matchedLocation.startsWith(AppRoutes.auth) ||
          state.matchedLocation == AppRoutes.signIn ||
          state.matchedLocation == AppRoutes.signUp;

      // If logged in and on an auth page, go to main
      if (isLoggedIn && isAuthPath) {
        return AppRoutes.main;
      }

      // No redirect
      return null;
    },

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
        path: AppRoutes.signUp,
        builder: (context, state) =>
            SignUpPage(onSignInTap: () => context.go(AppRoutes.signIn)),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) =>
            SignInPage(onSignUpTap: () => context.go(AppRoutes.signUp)),
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
          } else if (extra is Map<String, dynamic> &&
              extra.containsKey('product') &&
              extra['product'] is ProductModel) {
            return ProductDetailsView(
              product: extra['product'] as ProductModel,
              initialFlavor: extra['selectedFlavor'] as String?,
              initialSize: extra['selectedSize'] as String?,
            );
          }
          // Return a safe fallback or error state if data is missing
          return const Scaffold(
            body: Center(child: Text("Product data missing")),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        builder: (context, state) => const WishlistView(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const ProductSearchsPage(),
        pageBuilder: (context, state) =>buildPageWithTransition<ProductSearchsPage>(
          state: state,
          child: const ProductSearchsPage(),
          transitionType: PageTransitionType.scale,
        ),
        // pageBuilder: (context, state) =>buildPageWithTransition<ProductSearchsPage>(
        //   state: state,
        //   child: const ProductSearchsPage(), 
        //   transitionType: PageTransitionType.slideUp,

        //  )

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
});

enum PageTransitionType { fade, slideRight, slideUp, scale }

CustomTransitionPage<T> buildPageWithTransition<T>({
  required GoRouterState state,
  required Widget child,
  PageTransitionType transitionType = PageTransitionType.fade,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case PageTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
          // TODO: Handle this case.
        case PageTransitionType.slideRight:
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(animation),
            child: child,
          );
          // bottom to top
        case PageTransitionType.slideUp:
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                .animate(animation),
            child: child,
          );
          
        // case PageTransitionType.slideUp:
        //   return SlideTransition(
        //     position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        //         .animate(animation),
        //     child: child,
        //   );
          
        case PageTransitionType.scale:
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          );
      }
    },
  );
}
/// A listenable that triggers whenever the auth state changes.
class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(Ref ref) {
    ref.listen(authControllerProvider, (previous, next) {
      // Trigger update whenever value changes (login/logout)
      if (previous?.value != next.value) {
        notifyListeners();
      }
    });
  }
}
