import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/auth_view.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signin_page.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signup_page.dart';

/// Modular navigation routes for the authentication feature.
///
/// Encapsulates auth sub-routes into an isolated list of [RouteBase]
/// for clean composition in the root router.
class AuthRoutes {
  const AuthRoutes._();

  static const String auth = '/auth';
  static const String signIn = '/signin';
  static const String signUp = '/signup';

  static final List<RouteBase> routes = [
    GoRoute(
      path: auth,
      builder: (context, state) => const AuthView(),
    ),
    GoRoute(
      path: signIn,
      builder: (context, state) => SignInPage(
        onSignUpTap: () => context.go(signUp),
      ),
    ),
    GoRoute(
      path: signUp,
      builder: (context, state) => SignUpPage(
        onSignInTap: () => context.go(signIn),
      ),
    ),
  ];
}
