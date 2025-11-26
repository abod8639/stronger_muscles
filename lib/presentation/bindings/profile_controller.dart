import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<User?> currentUser = Rx<User?>(null);
  
  // Expose isLoading from AuthController
  RxBool get isLoading => _authController.isLoading;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _auth.currentUser;
    _auth.authStateChanges().listen((event) {
      currentUser.value = event;
    });
  }

  Future<void> signOut() async {
    await _authController.signOut();
  }

  Future<void> signInWithGoogle() async {
    await _authController.signInWithGoogle();
  }
}
