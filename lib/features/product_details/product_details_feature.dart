/// Public contracts and interfaces for the Product Details Feature.
/// External features must ONLY import this barrel file to interact with Product Details.
library;

// ── Domain Layer (Contracts & UseCases) ──────────────────────────────────────
export 'domain/repositories/product_details_repository.dart';
export 'domain/usecases/delete_product_review_usecase.dart';
export 'domain/usecases/get_product_details_usecase.dart';
export 'domain/usecases/get_product_reviews_usecase.dart';
export 'domain/usecases/get_user_product_review_usecase.dart';
export 'domain/usecases/submit_product_review_usecase.dart';

// ── Dependency Injection (Scoped Providers) ───────────────────────────────────
export 'product_details_providers.dart';

// ── Presentation Controllers & State ──────────────────────────────────────────
export 'presentation/controllers/product_details_controller.dart'
    show
        productDetailsControllerProvider,
        ProductDetailsController,
        ProductDetailsState,
        ProductDetailsFamilyParams;
export 'presentation/controllers/product_reviews_controller.dart'
    show
        productReviewsControllerProvider,
        ProductReviewsController,
        userProductReviewProvider;

// ── Public Pages & Top-level Widgets ─────────────────────────────────────────
export 'presentation/pages/product_details_view.dart';
export 'presentation/widgets/build_product_badges.dart';

// ── Modular Routes ───────────────────────────────────────────────────────────
export 'product_details_routes.dart';
