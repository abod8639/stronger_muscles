/// Public contracts and interfaces for the Help & Support Feature.
///
/// External features must ONLY import this file to interact with Help & Support.
library;

// Domain Entities
export 'domain/entities/faq_entity.dart';
export 'domain/entities/support_channel_entity.dart';
export 'domain/entities/support_message_entity.dart';
export 'domain/entities/support_ticket_entity.dart';

// Domain Repositories (Contracts)
export 'domain/repositories/help_support_repository.dart';

// Domain UseCases
export 'domain/usecases/close_ticket_usecase.dart';
export 'domain/usecases/get_faqs_usecase.dart';
export 'domain/usecases/get_support_channels_usecase.dart';
export 'domain/usecases/get_ticket_details_usecase.dart';
export 'domain/usecases/get_user_tickets_usecase.dart';
export 'domain/usecases/send_ticket_message_usecase.dart';
export 'domain/usecases/submit_ticket_usecase.dart';

// Presentation State & DI
export 'presentation/controllers/help_support_controller.dart'
    show
        helpSupportControllerProvider,
        HelpSupportNotifier,
        HelpSupportState;
export 'presentation/controllers/help_support_di.dart'
    show
        helpSupportRepositoryProvider,
        getFaqsUseCaseProvider,
        getSupportChannelsUseCaseProvider,
        submitTicketUseCaseProvider,
        getUserTicketsUseCaseProvider,
        getTicketDetailsUseCaseProvider,
        sendTicketMessageUseCaseProvider,
        closeTicketUseCaseProvider;

// Presentation Routes
export 'help_support_routes.dart';

// Public UI Pages
export 'presentation/pages/help_support_view.dart';

// Presentation Helpers (ticket status colors, FAQ category labels)
export 'presentation/utils/help_support_ui.dart';
