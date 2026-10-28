/// Public contracts and interfaces for the Profile Feature.
///
/// External features must ONLY import this barrel file to interact with Profile.
library;

// Domain Entities
export 'domain/entities/address_entity.dart';

// Presentation Controllers
export 'presentation/controllers/address_controller.dart'
    show addressControllerProvider, AddressController;

// Public Dialogs / Presentation Helpers
export 'presentation/widgets/show_address_form.dart' show showAddressForm;
