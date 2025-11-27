
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

class CheckoutController extends GetxController {
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
      final order = OrderModel(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        orderDate: DateTime.now(),
        status: 'pending',
        items: _cartController.cartItems.map((item) => OrderItem(
          productId: item.id,
          productName: item.name,
          price: item.price,
          quantity: item.quantity,
          imageUrl: item.imageUrl.first,
        )).toList(),
        totalAmount: _cartController.totalPrice,
        shippingAddress: selectedAddress.value!.street, // Simplified for now
        trackingNumber: '',
      );

      await _orderRepository.createOrder(order);
      
      // Clear cart and navigate to success
      _cartController.clearCart();
      Get.offNamed(AppRoutes.orderSuccess);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
    } finally {
      isProcessing.value = false;
    }
  }
}
