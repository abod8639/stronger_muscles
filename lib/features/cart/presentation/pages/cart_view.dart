import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/app_base_app_bar.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/build_cart_content.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_error_view.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/empty_cart_view.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Production-ready Shopping Cart screen.
/// Implements strictly decoupled presentation:
/// - Zero direct controller dependencies on sibling features.
/// - Pure declarative routing for external navigation.
/// - Transient mutation error observation with non-intrusive snackbars.
class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final localizations = AppLocalizations.of(context)!;

    // Listen to transient cart mutation errors (e.g. stock limit exceeded)
    ref.listen<AsyncValue<List<CartItemEntity>>>(
      cartControllerProvider,
      (previous, next) {
        if (next is AsyncError && previous is AsyncData) {
          final error = next.error;
          final String message = error is Failure
              ? error.toMessage()
              : error.toString();

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'حسناً',
                textColor: Colors.white,
                onPressed: () {
                  ref.read(cartControllerProvider.notifier).clearError();
                },
              ),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: baseAppBar(context, localizations.cart),
      body: cartState.when(
        data: (items) => items.isEmpty
            ? EmptyCartView(
                onGoShopping: () => context.go(AppRoutes.home),
              )
            : CartContentList(items: items),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => CartErrorView(
          error: error,
          onRetry: () => ref.refresh(cartControllerProvider),
          onGoShopping: () => context.go(AppRoutes.home),
        ),
      ),
    );
  }
}
