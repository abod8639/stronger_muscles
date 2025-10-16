import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'package:google_sign_in/google_sign_in.dart';
class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoading = false.obs;
  // Google OAuth client ID (used by web/iOS config or manual flows).
  // Keep the ID here so it can be referenced where necessary.
  static const String googleClientId =
    '1610448649-iea7q6mqh0gkua47pjkjpab36lkqg7ff.apps.googleusercontent.com';

  // Use the singleton instance; platforms and plugin versions manage config.
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<User?> signInWithGoogle() async {
    try {
      isLoading.value = true;
      // Trigger the interactive sign-in flow using the plugin's authenticate
      // method (this version returns an account where `authentication` may
      // expose only `idToken`).
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null; // user cancelled

      // Obtain the auth details from the request (idToken expected)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential. accessToken may be unavailable on some
      // platforms, so pass null for accessToken.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: null,
      );

      // Once signed in, return the Firebase user
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
