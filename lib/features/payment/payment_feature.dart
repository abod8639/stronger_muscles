/// Public barrel file for the Payment feature module.
/// Strictly encapsulates internal data sources, DTOs, and mappers.
library;

// Domain Entities & Repositories
export 'domain/entities/payment_method_entity.dart';
export 'domain/entities/payment_result_entity.dart';
export 'domain/repositories/payment_repository.dart';

// UseCases
export 'domain/usecases/get_payment_methods_usecase.dart';
export 'domain/usecases/initiate_payment_usecase.dart';

// Presentation Layer (Controller, State, Widgets, Pages)
export 'presentation/controllers/payment_controller.dart';
export 'presentation/controllers/payment_state.dart';
export 'presentation/pages/payment_gateway_view.dart';
export 'presentation/widgets/payment_method_selector.dart';

// DI Providers & Modular Routes
export 'payment_providers.dart';
export 'payment_routes.dart';
