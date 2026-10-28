/// Public contracts and interfaces for the Notifications Feature.
///
/// External features must ONLY import this barrel file to interact with Notifications.
/// Internal DataSources, DTOs, and private implementations remain encapsulated.
library;

// Domain Entities & Repositories
export 'domain/entities/notification_entity.dart';
export 'domain/repositories/notification_repository.dart';

// Domain UseCases
export 'domain/usecases/get_notifications_usecase.dart';
export 'domain/usecases/get_unread_count_usecase.dart';
export 'domain/usecases/mark_as_read_usecase.dart';
export 'domain/usecases/mark_all_as_read_usecase.dart';
export 'domain/usecases/delete_notification_usecase.dart';

// Scoped Dependency Injection Providers
export 'notifications_providers.dart';

// Modular Routing
export 'notifications_routes.dart';

// Presentation State & Controllers
export 'presentation/controllers/notification_controller.dart'
    show
        notificationControllerProvider,
        unreadNotificationCountProvider,
        NotificationController,
        NotificationsState;

// Presentation Views & Widgets
export 'presentation/pages/notifications_view.dart';
export 'presentation/widgets/notification_item_card.dart';
