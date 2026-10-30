import 'package:go_router/go_router.dart';
import '../../routes/routes.dart';
import 'presentation/pages/help_support_view.dart';

/// Modular routes configuration for Help & Support feature.
class HelpSupportRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.helpSupport,
      builder: (context, state) {
        String? ticketId;
        String? ticketNumber;
        bool openActiveTicket = false;

        final extra = state.extra;
        if (extra is String) {
          ticketId = extra;
        } else if (extra is Map) {
          ticketId = extra['ticket_id']?.toString() ??
              extra['ticketId']?.toString();
          ticketNumber = extra['ticket_number']?.toString() ??
              extra['ticketNumber']?.toString();
          openActiveTicket = extra['open_active_ticket'] == true;
        }

        ticketId ??= state.uri.queryParameters['ticket_id'] ??
            state.uri.queryParameters['ticketId'];
        ticketNumber ??= state.uri.queryParameters['ticket_number'] ??
            state.uri.queryParameters['ticketNumber'];

        return HelpSupportView(
          initialTicketId: ticketId,
          initialTicketNumber: ticketNumber,
          openActiveTicket: openActiveTicket,
        );
      },
    ),
  ];
}
