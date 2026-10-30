import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_checkout_bottom_bar.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_content_list.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final hasItems = cartState.valueOrNull?.isNotEmpty ?? false;

    // Listen to transient cart mutation errors (e.g. stock limit exceeded)
    ref.listen<AsyncValue<List<CartItemEntity>>>(
      cartControllerProvider,
      (previous, next) {
        if (next is AsyncError && previous is AsyncData) {
          AppSnackBar.showError(
            context,
            AppErrorCard.messageFor(next.error, l10n),
            actionLabel: l10n.ok,
            onAction: ref.read(cartControllerProvider.notifier).clearError,
          );
        }
      },
    );

    void goShopping() => context.go(AppRoutes.home);

    return Scaffold(
      appBar: baseAppBar(context, l10n.cart),
      bottomNavigationBar: hasItems ? const CartCheckoutBottomBar() : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: cartState.when(
          // Keep showing cached items while a mutation error is surfaced as a snackbar.
          skipError: hasItems,
          data: (items) => items.isEmpty
              ? EmptyCartView(onGoShopping: goShopping)
              : CartContentList(items: items),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => CartErrorView(
            error: error,
            onRetry: () => ref.invalidate(cartControllerProvider),
            onGoShopping: goShopping,
          ),
        ),
      ),
    );
  }
}
