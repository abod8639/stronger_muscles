/// Public contract for the Authentication Feature module.
///
/// Exposes strictly public contracts (Entities, UseCases, Providers, and Routes)
/// while encapsulating internal implementations (DataSources, Models, Mappers, and Widgets).
library;

// Domain Entities
export 'domain/entities/user_entity.dart';

// Domain Repositories (Contracts)
export 'domain/repositories/auth_repository.dart';

// Domain UseCases
export 'domain/usecases/get_current_user_usecase.dart';
export 'domain/usecases/google_sign_in_usecase.dart';
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/usecases/register_usecase.dart';
export 'domain/usecases/update_profile_usecase.dart';

// State Management & Public Providers
export 'presentation/controllers/auth_controller.dart'
    show AuthController, authControllerProvider;
export 'presentation/controllers/auth_di.dart'
    show
        authRepositoryProvider,
        loginUseCaseProvider,
        registerUseCaseProvider,
        logoutUseCaseProvider,
        getCurrentUserUseCaseProvider,
        googleSignInUseCaseProvider,
        updateProfileUseCaseProvider;

// Feature Modular Routing
export 'auth_routes.dart';
