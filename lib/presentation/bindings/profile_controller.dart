import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileController extends GetxController {
  static const String googleClientId =
      '1610448649-iea7q6mqh0gkua47pjkjpab36lkqg7ff.apps.googleusercontent.com';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignInAuthentication _googleSignIn = GoogleSignInAuthentication(
    idToken: googleClientId,
  );
  //  serverClientId: googleClientId,);



  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((event) {
      user.value = event;
    });
  }

  

  // Future<void> signInWithGoogle() async {
  //   try {
  //     isLoading.value = true;
  //     final GoogleSignInAccount? googleUser = await _googleSignIn
  //         .authenticate();
  //     if (googleUser == null) {
  //       return;
  //     }
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     await _auth.signInWithCredential(credential);
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     print("Error during Google sign-in: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
