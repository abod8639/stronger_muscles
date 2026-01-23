import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionController extends GetxController {
  final RxBool isConnected = true.obs;
  
  StreamSubscription? _subscription;
  late final InternetConnection _internetConnection;

  @override
  void onInit() {
    super.onInit();
    _internetConnection = InternetConnection();
    _startMonitoring();
  }

  void _startMonitoring() {
    _checkInitialStatus();

    _subscription = _internetConnection.onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          isConnected.value = true;
          break;
        case InternetStatus.disconnected:
          isConnected.value = false;
          break;
      }
    });
  }

  Future<void> _checkInitialStatus() async {
    bool hasAccess = await _internetConnection.hasInternetAccess;
    isConnected.value = hasAccess;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}