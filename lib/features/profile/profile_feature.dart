/// Public contracts and interfaces for the Profile Feature.
///
/// External features must ONLY import this barrel file to interact with Profile.
/// DataSources and internal widgets remain encapsulated.
library;

// Domain Entities & Repositories
export 'domain/entities/address_entity.dart';
export 'domain/repositories/address_repository.dart';

// Cross-Feature DTOs (Hive Models shared with other features)
export 'data/models/address_model.dart';
export 'data/models/localized_string_model.dart';

// Domain UseCases
export 'domain/usecases/get_addresses_usecase.dart';
export 'domain/usecases/save_address_usecase.dart';
export 'domain/usecases/delete_address_usecase.dart';
export 'domain/usecases/set_default_address_usecase.dart';

// Scoped Dependency Injection Providers
export 'profile_providers.dart';

// Modular Routing
export 'profile_routes.dart';

// Presentation State & Controllers
export 'presentation/controllers/address_controller.dart'
    show
        addressControllerProvider,
        AddressController,
        addressFormLoadingProvider,
        addressFormSelectedLabelProvider;
export 'presentation/controllers/profile_controller.dart'
    show profileControllerProvider, ProfileController;
export 'package:stronger_muscles/core/localization/language_controller.dart'
    show languageControllerProvider, LanguageController;
export 'presentation/controllers/theme_controller.dart'
    show themeControllerProvider, ThemeController;

// Public Views & Dialog Helpers
export 'presentation/pages/profile_page.dart';
export 'presentation/pages/edit_user_info.dart';
export 'presentation/widgets/show_address_form.dart' show showAddressForm;
