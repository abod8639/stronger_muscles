import 'package:get/get.dart';
import 'package:stronger_muscles/data/services/paymob_service.dart';

class PaymobController extends GetxController {
  final PaymobService _paymobService = PaymobService();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> initiatePayment({
    required double amount,
    required String currency,
    // Add user details if available, otherwise defaults will be used in service
    String firstName = 'NA',
    String lastName = 'NA',
    String email = 'NA',
    String phone = 'NA',
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 1. Authentication
      final String authToken = await _paymobService.getAuthToken();
      print("Paymob Auth Token: $authToken");

      // 2. Register Order
      // Convert amount to cents (string)
      final String amountCents = (amount * 100).toInt().toString();
      final int orderId = await _paymobService.getOrderId(
        authToken: authToken,
        amountCents: amountCents,
      );
      print("Paymob Order ID: $orderId");

      // 3. Request Payment Key
      final String paymentKey = await _paymobService.getPaymentKey(
        authToken: authToken,
        amountCents: amountCents,
        orderId: orderId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );
      print("Paymob Payment Key: $paymentKey");

      // 4. Launch WebView (or emit state for UI to handle)
      _launchPaymentWebView(paymentKey);
    } catch (e) {
      errorMessage.value = e.toString();
      print("Paymob Error: $e");
      Get.snackbar('Payment Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _launchPaymentWebView(String paymentKey) {
    final String url = paymentKey;
    print("Navigate to: $url");

    // For now, we will just print the URL.
    // In a real app, use url_launcher or navigate to a WebView page.
    // Example: Get.to(() => PaymentWebView(url: url));
  }
}
