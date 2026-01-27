import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../routes/routes.dart';

const String _googleWebClientId =
    '1610448649-0hqb4e42ik3lg90q7nktbu3704orrd2k.apps.googleusercontent.com';
// const String _defaultUserId = '0';
const Duration _snackbarDuration = Duration(seconds: 5);
const String _errorGoogleSignIn = 'خطأ في تسجيل الدخول عبر Google';
const String _errorCheckUser = 'خطأ في التحقق من بيانات المستخدم';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxString userId = ''.obs;
  final RxBool isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxString token = ''.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
      }
    } catch (e) {
      print('❌ Auth: Error checking current user: $e');
      Get.snackbar(
        'خطأ',
        _errorCheckUser,
        snackPosition: SnackPosition.BOTTOM,
        duration: _snackbarDuration,
      );
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await _googleSignIn.initialize(serverClientId: _googleWebClientId);
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();


      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      userId.value = userCredential.user!.uid;

      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;
        final user = await _authService.googleSignIn(
          email: firebaseUser.email ?? googleUser.email,
          name: firebaseUser.displayName ?? googleUser.displayName ?? 'User',
          photoUrl: firebaseUser.photoURL,
        );
        currentUser.value = user;
        Get.offAllNamed(AppRoutes.main);
      }

      return userCredential.user;
    } catch (e) {
      Get.snackbar('خطأ', '$_errorGoogleSignIn ${e.toString()}');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      print('🔐 محاولة تسجيل الدخول: $email');

      // Backend API Login only (Firebase removed for email/password)
      final user = await _authService.login(email: email, password: password);
      print('✅ نجح تسجيل الدخول في Backend: ${user.email}');

      currentUser.value = user;

      Get.offAllNamed(AppRoutes.main);
      print('✅ تم الانتقال إلى الصفحة الرئيسية');
    } catch (e) {
      print('❌ خطأ تسجيل الدخول: $e');

      // Display user-friendly error message
      String errorMessage = e.toString();

      // Clean up error message if it's too technical
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '').trim();
      }

      Get.snackbar(
        'خطأ في تسجيل الدخول',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
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

      print('📝 محاولة إنشاء حساب: $email');

      // Backend API Register only (Firebase removed for email/password)
      final user = await _authService.register(
        email: email,
        password: password,
        name: name,
      );
      print('✅ نجح إنشاء الحساب في Backend: ${user.email}');

      currentUser.value = user;

      Get.offAllNamed(AppRoutes.main);
      print('✅ تم الانتقال إلى الصفحة الرئيسية');
    } catch (e) {
      print('❌ خطأ إنشاء الحساب: $e');

      // Display user-friendly error message
      String errorMessage = e.toString();

      // Clean up error message if it's too technical
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '').trim();
      }

      Get.snackbar(
        'خطأ في إنشاء الحساب',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    try {
      isLoading.value = true;

      final updatedUser = await _authService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
      );

      currentUser.value = updatedUser;
      print('✅ تم تحديث بيانات المستخدم');
    } catch (e) {
      print('❌ خطأ في تحديث البيانات: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _authService.logout();
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/login'); // Adjust route
  }

  Future<void> deleteUser() async {
    await _authService.deleteUser();
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/login'); // Adjust route
  }
}
