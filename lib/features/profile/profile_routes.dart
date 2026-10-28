import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/edit_user_info.dart';
import 'package:stronger_muscles/features/profile/presentation/pages/profile_page.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Modular GoRouter route definitions for the Profile feature.
class ProfileRoutes {
  static const String profilePath = AppRoutes.profile;
  static const String editUserInfoPath = AppRoutes.editUserInfo;

  /// Dedicated StatefulShellBranch for nested bottom navigation tabs.
  static StatefulShellBranch get branch => StatefulShellBranch(
        routes: [
          GoRoute(
            path: profilePath,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      );

  /// Standalone routes for the Profile feature.
  static List<RouteBase> get standaloneRoutes => [
        GoRoute(
          path: editUserInfoPath,
          builder: (context, state) => const EditUserInfoView(),
        ),
      ];

  /// Standalone GoRoute for profile page if used outside shell branch.
  static GoRoute get route => GoRoute(
        path: profilePath,
        builder: (context, state) => const ProfilePage(),
      );
}
