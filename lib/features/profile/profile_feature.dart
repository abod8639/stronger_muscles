/// Public contracts and interfaces for the Profile Feature.
///
/// External features must ONLY import this barrel file to interact with Profile.
library;

// Domain Entities & Models
export 'domain/entities/address_entity.dart';
export 'data/models/address_model.dart';

// Presentation Controllers
export 'presentation/controllers/address_controller.dart'
    show addressControllerProvider, AddressController;
export 'presentation/controllers/language_controller.dart'
    show languageControllerProvider, LanguageController;

// Public Dialogs / Presentation Helpers
export 'presentation/widgets/show_address_form.dart' show showAddressForm;
