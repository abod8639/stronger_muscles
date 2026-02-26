import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

class CheckoutController extends GetxController {
  // final AddressController _addressController = Get.find<AddressController>();
  final CartController _cartController = Get.find<CartController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final OrderRepository _orderRepository = OrderRepository();
  final RxInt currentStep = 0.obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final RxString selectedPaymentMethod = 'cash'.obs; // 'cash' or 'card'
  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
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
      final payload = {
        "address_id": selectedAddress.value!.id,
        "payment_method": selectedPaymentMethod.value,
        "notes": _cartController.notesController.text,
        "items": _cartController.cartItems.map((item) {
          return {
            "product_id": item.product.id,
            "quantity": item.quantity,
            "selected_flavor": item.selectedFlavor,
            "selected_size": item.selectedSize,
          };
        }).toList(),
      };

      await _orderRepository.createOrder(payload);
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
