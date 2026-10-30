import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/cart/cart_routes.dart';
import 'package:stronger_muscles/features/home/home_routes.dart';
import 'package:stronger_muscles/main_page.dart';
import 'package:stronger_muscles/features/order/order_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/pages/product_details_view.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/edit_user_info.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/profile_page.dart';
import 'package:stronger_muscles/features/wishlist/presentation/pages/wishlist_view.dart';
import 'package:stronger_muscles/features/search/presentation/pages/search_page.dart';
import 'package:stronger_muscles/features/checkout/checkout_routes.dart';
import 'package:stronger_muscles/features/notifications/notifications_routes.dart';
import 'package:stronger_muscles/features/help_support/help_support_routes.dart';
import 'package:stronger_muscles/features/payment/payment_routes.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class AppRoutes {
  static const String main = '/';
  static const String auth = '/auth';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String products = '/products';
  static const String productDetails = '/product_details';
  static const String wishlist = '/wishlist';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order_success';
  static const String editUserInfo = '/edit_user_info';
  static const String orderView = '/order_view';
  static const String orderDetails = '/order_details';
  static const String notifications = '/notifications';
  static const String helpSupport = '/help_support';
  static const String paymentGateway = '/payment_gateway';
}

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);
  ref.onDispose(routerNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.main,
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoggedIn = authState.valueOrNull != null;
      
      final isAuthPath = state.matchedLocation.startsWith(AppRoutes.auth) ||
          state.matchedLocation == AppRoutes.signIn ||
          state.matchedLocation == AppRoutes.signUp;

      // If logged in and on an auth page, go to profile
      if (isLoggedIn && isAuthPath) {
        return AppRoutes.profile;
      }

      // No redirect
      return null;
    },

    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainPage(navigationShell: navigationShell),
        branches: [
          HomeRoutes.branch,
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.wishlist,
                builder: (context, state) => const WishlistView(),
              ),
            ],
          ),
          CartRoutes.branch,
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      ...HomeRoutes.standaloneRoutes,
      ...AuthRoutes.routes,
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ProductEntity) {
            return ProductDetailsView(product: extra);
          } else if (extra is ProductModel) {
            return ProductDetailsView.fromModel(model: extra);
          } else if (extra is Map<String, dynamic> &&
              extra.containsKey('product')) {
            final p = extra['product'];
            final productEntity = p is ProductEntity
                ? p
                : (p is ProductModel ? p.toEntity() : null);
            if (productEntity != null) {
              return ProductDetailsView(
                product: productEntity,
                initialFlavor: extra['selectedFlavor'] as String?,
                initialSize: extra['selectedSize'] as String?,
              );
            }
          }
          // Return a safe fallback or error state if data is missing
          return Scaffold(
            body: Center(
              child: Text(
                AppLocalizations.of(context)?.productDataMissing ??
                    "Product data missing",
              ),
            ),
          );
        },
      ),
      GoRoute(
        
        path: AppRoutes.search,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is bool) {
            return SearchPage(isFocused: extra);
          }
          return const SearchPage(isFocused: true);
        },
      ),
      ...CheckoutRoutes.routes,
      GoRoute(
        path: AppRoutes.editUserInfo,
        builder: (context, state) => const EditUserInfoView(),
      ),
      ...OrderRoutes.routes,
      ...NotificationsRoutes.routes,
      ...HelpSupportRoutes.routes,
      ...PaymentRoutes.routes,
      ...ProductRoutes.routes,
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

