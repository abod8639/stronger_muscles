import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/internet_connection_controller.dart';

final InternetConnectionController internetConnectionController =
    Get.find<InternetConnectionController>();

//

Future<bool> checkInternetConnection(Function() function) async {
  if (internetConnectionController.isConnected.value) {
    function();
    return true;
  } else {
    print("no internet connection");
    return false;
  }
}
