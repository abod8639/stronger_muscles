import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionController extends GetxController {
  final RxBool isConnected = true.obs;
  late InternetConnection _internetConnection;

  @override
  void onInit() {
    super.onInit();
    _initInternetConnection();
  }

  void _initInternetConnection() {
    _internetConnection = InternetConnection.createInstance(

      // createDefaultInstance: true,
      // useDefaultInstanceAsFallback: true,
    );

    // Listen to connection status changes
    _internetConnection.onStatusChange.listen((status) {
      bool connected = (status == InternetStatus.connected);
      isConnected.value = connected;
    });

    // Check initial connection status
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    try {
      bool result = await _internetConnection.hasInternetAccess;
      isConnected.value = result;
    } catch (e) {
      isConnected.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
