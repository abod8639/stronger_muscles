import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/routes/routes.dart';
import 'presentation/pages/support_chat_page.dart';

class SupportChatRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.supportChat,
      builder: (context, state) {
        String ticketId = '';
        final extra = state.extra;

        if (extra is String) {
          ticketId = extra;
        } else if (extra is Map) {
          ticketId = extra['ticket_id']?.toString() ??
              extra['ticketId']?.toString() ??
              extra['id']?.toString() ??
              '';
        }

        if (ticketId.isEmpty) {
          ticketId = state.uri.queryParameters['ticket_id'] ??
              state.uri.queryParameters['ticketId'] ??
              '';
        }

        return SupportChatPage(ticketId: ticketId);
      },
    ),
  ];
}

