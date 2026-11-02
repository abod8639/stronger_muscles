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
        bool isFocused = true;
        String? initialQuery = state.uri.queryParameters['q'];
        String? initialBrand = state.uri.queryParameters['brand'];

        if (extra is bool) {
          isFocused = extra;
        } else if (extra is String) {
          initialQuery = extra;
          isFocused = false;
        } else if (extra is Map<String, dynamic>) {
          isFocused = extra['isFocused'] as bool? ?? false;
          initialQuery = extra['query'] as String?;
          initialBrand = extra['brand'] as String?;
        }

        return SearchPage(
          isFocused: isFocused,
          initialQuery: initialQuery,
          initialBrand: initialBrand,
        );
      },
    ),
  ];
}
