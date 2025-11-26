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

      // Obtain the auth details from the request (idToken expected)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential. accessToken may be unavailable on some
      // platforms, so pass null for accessToken.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: null,
      );

      // Once signed in, return the Firebase user
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      Get.snackbar('Error', 'Google Sign-In failed: ${e.toString()}');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = e.message ?? message;
      }
      Get.snackbar('Error', message);
      return null;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = e.message ?? message;
      }
      Get.snackbar('Error', message);
      return null;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
