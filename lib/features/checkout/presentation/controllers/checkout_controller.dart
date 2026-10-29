import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/error.dart';
import '../../../cart/cart_feature.dart';
import '../../../profile/profile_feature.dart';
import '../../domain/entities/checkout_params.dart';
import '../../domain/entities/checkout_quote.dart';
import '../../domain/entities/checkout_result_entity.dart';
import '../../domain/usecases/place_order_usecase.dart';
import 'checkout_di.dart';

@immutable
class CheckoutState {
  const CheckoutState({
    this.currentStep = 0,
    this.selectedAddress,
    this.selectedPaymentMethod = 'cash',
    this.notes = '',
    this.orderSubmission = const AsyncData(null),
  });

  final int currentStep;
  final AddressEntity? selectedAddress;
  final String selectedPaymentMethod;
  final String notes;
  final AsyncValue<CheckoutResultEntity?> orderSubmission;

  bool get isProcessing => orderSubmission.isLoading;

  bool get hasError => orderSubmission.hasError;

  Failure? get failure {
    final err = orderSubmission.error;
    if (err is Failure) return err;
    if (err != null) return Failure(message: err.toString());
    return null;
  }

  CheckoutState copyWith({
    int? currentStep,
    AddressEntity? selectedAddress,
    String? selectedPaymentMethod,
    String? notes,
    AsyncValue<CheckoutResultEntity?>? orderSubmission,
  }) {
    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      notes: notes ?? this.notes,
      orderSubmission: orderSubmission ?? this.orderSubmission,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckoutState &&
          runtimeType == other.runtimeType &&
          currentStep == other.currentStep &&
          selectedAddress == other.selectedAddress &&
          selectedPaymentMethod == other.selectedPaymentMethod &&
          notes == other.notes &&
          orderSubmission == other.orderSubmission;

  @override
  int get hashCode => Object.hash(
        currentStep,
        selectedAddress,
        selectedPaymentMethod,
        notes,
        orderSubmission,
      );
}

/// Converts cart lines into the items sent to the server for pricing and ordering.
List<CheckoutItemEntity> checkoutItemsFromCart(List<CartItemEntity> cartItems) {
  return cartItems.map((cartItem) {
    final unitPrice =
        cartItem.product.getEffectivePriceForSize(cartItem.selectedSize);
    return CheckoutItemEntity(
      productId: cartItem.product.id,
      productName: cartItem.product.getLocalizedName(),
      quantity: cartItem.quantity,
      unitPrice: unitPrice,
      selectedFlavor: cartItem.selectedFlavor,
      selectedSize: cartItem.selectedSize,
      imageUrl: cartItem.primaryImageUrl,
    );
  }).toList();
}

/// Server price for the current cart (subtotal, delivery fee, tax, total).
///
/// Re-fetched whenever the cart changes; `null` while the cart is empty.
final checkoutQuoteProvider =
    FutureProvider.autoDispose<CheckoutQuote?>((ref) async {
  final cartItems = ref.watch(
    cartControllerProvider.select((cart) => cart.valueOrNull),
  );
  if (cartItems == null || cartItems.isEmpty) return null;

  final result = await ref
      .read(getCheckoutQuoteUseCaseProvider)
      .call(checkoutItemsFromCart(cartItems));

  return result.fold((failure) => throw failure, (quote) => quote);
});

final checkoutControllerProvider =
    StateNotifierProvider<CheckoutController, CheckoutState>((ref) {
  return CheckoutController(ref);
});

class CheckoutController extends StateNotifier<CheckoutState> {
  CheckoutController(this._ref)
      : _testPlaceOrderUseCase = null,
        _testCartItems = null,
        _onClearCart = null,
        super(const CheckoutState()) {
    _initialize();
  }

  CheckoutController.test({
    required PlaceOrderUseCase placeOrderUseCase,
    AddressEntity? initialAddress,
    List<CartItemEntity>? testCartItems,
    Future<void> Function()? onClearCart,
  })  : _ref = null,
        _testPlaceOrderUseCase = placeOrderUseCase,
        _testCartItems = testCartItems,
        _onClearCart = onClearCart,
        super(CheckoutState(selectedAddress: initialAddress));

  final Ref? _ref;
  final PlaceOrderUseCase? _testPlaceOrderUseCase;
  final List<CartItemEntity>? _testCartItems;
  final Future<void> Function()? _onClearCart;

  PlaceOrderUseCase get _placeOrderUseCase =>
      _testPlaceOrderUseCase ?? _ref!.read(placeOrderUseCaseProvider);

  void _initialize() {
    if (_ref == null) return;

    _ref.listen<AsyncValue<List<AddressEntity>>>(
      addressControllerProvider,
      (previous, next) {
        final addresses = next.valueOrNull ?? [];
        if (state.selectedAddress == null && addresses.isNotEmpty) {
          final defaultAddr = addresses.where((a) => a.isDefault).firstOrNull ??
              addresses.first;
          state = state.copyWith(selectedAddress: defaultAddr);
        } else if (state.selectedAddress != null) {
          final exists =
              addresses.any((a) => a.id == state.selectedAddress!.id);
          if (!exists) {
            final fallback = addresses.where((a) => a.isDefault).firstOrNull ??
                (addresses.isNotEmpty ? addresses.first : null);
            state = state.copyWith(selectedAddress: fallback);
          } else {
            final updated =
                addresses.firstWhere((a) => a.id == state.selectedAddress!.id);
            state = state.copyWith(selectedAddress: updated);
          }
        }
      },
    );

    final initialAddresses =
        _ref.read(addressControllerProvider).valueOrNull ?? [];
    if (initialAddresses.isNotEmpty) {
      final defaultAddr =
          initialAddresses.where((a) => a.isDefault).firstOrNull ??
              initialAddresses.first;
      state = state.copyWith(selectedAddress: defaultAddr);
    }
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setAddress(AddressEntity address) {
    state = state.copyWith(selectedAddress: address);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void resetError() {
    if (state.orderSubmission.hasError) {
      state = state.copyWith(orderSubmission: const AsyncData(null));
    }
  }

  /// Submits the checkout order without UI dependencies or direct BuildContext manipulation.
  Future<void> placeOrder() async {
    // Transaction guard: prevent duplicate submission while in flight
    if (state.isProcessing) return;

    if (state.selectedAddress == null) {
      state = state.copyWith(
        orderSubmission: AsyncError(
          const ValidationFailure(
            message: 'يرجى تحديد عنوان التوصيل أولاً قبل إتمام الطلب',
          ),
          StackTrace.current,
        ),
      );
      return;
    }

    final cartItems = _testCartItems ??
        (_ref?.read(cartControllerProvider).valueOrNull ?? <CartItemEntity>[]);

    if (cartItems.isEmpty) {
      state = state.copyWith(
        orderSubmission: AsyncError(
          const ValidationFailure(
            message: 'سلة المشتريات فارغة، يرجى إضافة منتجات أولاً',
          ),
          StackTrace.current,
        ),
      );
      return;
    }

    state = state.copyWith(orderSubmission: const AsyncLoading());

    final checkoutItems = checkoutItemsFromCart(cartItems);

    final params = CheckoutParams(
      addressId: state.selectedAddress!.id,
      paymentMethod: state.selectedPaymentMethod,
      notes: state.notes,
      customerName: state.selectedAddress?.fullName,
      items: checkoutItems,
    );

    // Functional Either handling without try-catch blocks
    final result = await _placeOrderUseCase(params);

    await result.fold(
      (failure) async {
        final stackTrace = failure.stackTrace ?? StackTrace.current;
        state = state.copyWith(
          orderSubmission: AsyncError<CheckoutResultEntity?>(
            failure,
            stackTrace,
          ),
        );
      },
      (resultEntity) async {
        // Clear cart after verified order placement
        if (_onClearCart != null) {
          await _onClearCart();
        } else if (_ref != null) {
          await _ref.read(cartControllerProvider.notifier).clearCart();
        }

        state = state.copyWith(
          orderSubmission: AsyncData(resultEntity),
        );
      },
    );
  }
}
