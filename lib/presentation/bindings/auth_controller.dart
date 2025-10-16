import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'package:google_sign_in/google_sign_in.dart';
class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // v7+ of google_sign_in uses a singleton instance and exposes
      // `authenticate()` for interactive sign-in. The returned
      // GoogleSignInAccount exposes `authentication` (synchronously)
      // which currently contains only `idToken`.
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();
      if (googleUser == null) return null; // user cancelled

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // New API currently provides only idToken. accessToken may be
      // unavailable on some platforms, so pass it as null.
      final AuthCredential credential = GoogleAuthProvider.credential(

        idToken: googleAuth.idToken,
        accessToken: null,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }
}
