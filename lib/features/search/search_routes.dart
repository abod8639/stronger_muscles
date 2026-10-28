import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/search/presentation/pages/search_page.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Modular routes for the Search feature.
class SearchRoutes {
  /// Standalone routes for the Search feature.
  static List<RouteBase> get routes => [
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
      ];
}
