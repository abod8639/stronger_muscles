/// Public contracts and interfaces for the Checkout Feature.
///
/// External features must ONLY import this file to interact with Checkout.
library;

// Domain Entities
export 'domain/entities/checkout_params.dart';
export 'domain/entities/checkout_result_entity.dart';

// Domain Repositories (Contracts)
export 'domain/repositories/checkout_repository.dart';

// Domain UseCases
export 'domain/usecases/place_order_usecase.dart';

// Presentation State & DI
export 'presentation/controllers/checkout_controller.dart'
    show checkoutControllerProvider, CheckoutController, CheckoutState;
export 'presentation/controllers/checkout_di.dart'
    show
        checkoutRepositoryProvider,
        placeOrderUseCaseProvider;

// Presentation Routes
export 'checkout_routes.dart';

// Public UI Pages
export 'presentation/pages/checkout_view.dart';
export 'presentation/pages/order_success_view.dart';
