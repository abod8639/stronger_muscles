import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../routes/routes.dart';
import 'base_controller.dart';

const String _googleWebClientId =
    '1610448649-0hqb4e42ik3lg90q7nktbu3704orrd2k.apps.googleusercontent.com';
const String _errorGoogleSignIn = 'خطأ في تسجيل الدخول عبر Google';
const String _errorCheckUser = 'خطأ في التحقق من بيانات المستخدم';

class AuthController extends BaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxString userId = ''.obs;
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
        _onAuthSuccess(user);
      }
    } catch (e) {
      handleError(e, message: _errorCheckUser);
    }
  }

  void _onAuthSuccess(UserModel user) {
    currentUser.value = user;
    isLoggedIn.value = true;
    userId.value = user.id.toString();
    Get.offAllNamed(AppRoutes.main);
  }

  Future<User?> signInWithGoogle() async {
    try {
      setLoading(true);
      await _googleSignIn.initialize(serverClientId: _googleWebClientId);
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();


      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;
        final user = await _authService.googleSignIn(
          email: firebaseUser.email ?? googleUser.email,
          name: firebaseUser.displayName ?? googleUser.displayName ?? 'User',
          photoUrl: firebaseUser.photoURL,
        );
        _onAuthSuccess(user);
      }

      return userCredential.user;
    } catch (e) {
      handleError(e, message: _errorGoogleSignIn);
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      setLoading(true);
      resetState();

      debugPrint('🔐 محاولة تسجيل الدخول: $email');

      final user = await _authService.login(email: email, password: password);
      debugPrint('✅ نجح تسجيل الدخول في Backend: ${user.email}');

      _onAuthSuccess(user);
    } catch (e) {
      handleError(e, title: 'خطأ في تسجيل الدخول');
    } finally {
      setLoading(false);
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      setLoading(true);
      resetState();

      debugPrint('📝 محاولة إنشاء حساب: $email');

      final user = await _authService.register(
        email: email,
        password: password,
        name: name,
      );
      debugPrint('✅ نجح إنشاء الحساب في Backend: ${user.email}');

      _onAuthSuccess(user);
    } catch (e) {
      handleError(e, title: 'خطأ في إنشاء الحساب');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    try {
      setLoading(true);

      final updatedUser = await _authService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
      );

      currentUser.value = updatedUser;
      showSuccessSnackbar(title: 'نجاح', message: 'تم تحديث بيانات المستخدم');
    } catch (e) {
      handleError(e, title: 'خطأ في تحديث البيانات');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _authService.logout();
      currentUser.value = null;
      isLoggedIn.value = false;
      userId.value = '';
      Get.offAllNamed('/login'); // Adjust route
    } catch (e) {
      handleError(e, message: 'فشل تسجيل الخروج');
    }
  }

  Future<void> deleteUser() async {
    try {
      await _authService.deleteUser();
      await signOut();
    } catch (e) {
      handleError(e, message: 'فشل حذف الحساب');
    }
  }
}
