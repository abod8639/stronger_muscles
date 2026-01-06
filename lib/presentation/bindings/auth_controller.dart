import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final AuthService _authService = Get.put(
    AuthService(),
  ); // Ensure AuthService is initialized

  final RxBool isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  static const String webClientId =
      '1610448649-0hqb4e42ik3lg90q7nktbu3704orrd2k.apps.googleusercontent.com';

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      currentUser.value = user;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await _googleSignIn.initialize(serverClientId: webClientId);
      final GoogleSignInAccount googleUser = await _googleSignIn
          .authenticate();

      // if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // accessToken: null,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // إرسال معلومات المستخدم إلى Backend
      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;
        final user = await _authService.googleSignIn(
          email: firebaseUser.email ?? googleUser.email,
          name: firebaseUser.displayName ?? googleUser.displayName ?? 'User',
          photoUrl: firebaseUser.photoURL,
        );
        currentUser.value = user;
        Get.offAllNamed('/home'); // انتقل إلى الصفحة الرئيسية
      }

      return userCredential.user;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تسجيل الدخول عبر Google: ${e.toString()}');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      // 1. Firebase Login (Optional, based on requirement)
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // 2. Backend API Login
      final user = await _authService.login(email: email, password: password);
      currentUser.value = user;

      Get.offAllNamed('/home'); // Or main route
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Auth Error', e.message ?? 'Login failed');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      isLoading.value = true;
      // 1. Firebase Register
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Backend API Register
      final user = await _authService.register(
        email: email,
        password: password,
        name: name,
      );
      currentUser.value = user;

      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Auth Error', e.message ?? 'Registration failed');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _authService.logout();
    currentUser.value = null;
    Get.offAllNamed('/login'); // Adjust route
  }
}
