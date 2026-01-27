import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

class CheckoutController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final CartController _cartController = Get.find<CartController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final OrderRepository _orderRepository = OrderRepository();

  final RxInt currentStep = 0.obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final RxString selectedPaymentMethod = 'cod'.obs; // 'cod' or 'card'
  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-select default address if available
    if (_profileController.addresses.isNotEmpty) {
      selectedAddress.value = _profileController.addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => _profileController.addresses.first,
      );
    }
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void setAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> placeOrder() async {
    if (selectedAddress.value == null) {
      Get.snackbar('Error', 'Please select a shipping address');
      return;
    }

    isProcessing.value = true;

    try {
      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      final order = OrderModel(
        id: orderId,
        userId: _authController.currentUser.value?.id.toString() ?? '0',
        orderDate: DateTime.now(),
        status: 'pending',
        addressId: selectedAddress.value!.id.toString(),
        subtotal: _cartController.totalPrice,
        totalAmount: _cartController.totalPrice,
        createdAt: DateTime.now(),
        discount: 0,
        shippingCost: 50,
        notes: 'not${_cartController.notesController.text}',
        shippingAddressSnapshot: '',
        shippingAddress: selectedAddress.value!.street,
        trackingNumber: '',
        paymentMethod: '',
        paymentStatus: '',
        updatedAt: DateTime.now(),
        items: _cartController.cartItems
            .map(
              (item) => OrderItemModel(
                id: 'item-${DateTime.now().millisecondsSinceEpoch}-${item.product.id}',
                orderId: orderId,
                productId: item.product.id,
                productName: item.product.name,
                unitPrice: item.product.effectivePrice,
                quantity: item.quantity,
                subtotal: item.product.effectivePrice * item.quantity,
                imageUrl: item.product.imageUrls.first,
                selectedFlavor: item.selectedFlavor,
                selectedSize: item.selectedSize,
                createdAt: DateTime.now(),
              ),
            )
            .toList(),
      );

      await _orderRepository.createOrder(order);
      _cartController.clearCart();
      Get.offNamed(AppRoutes.orderSuccess);
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
      print(e);
    } finally {
      isProcessing.value = false;
    }
  }
}
