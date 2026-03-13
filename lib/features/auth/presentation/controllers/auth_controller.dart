import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  UserModel? build() {
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });

    _initUser();
    return null;
  }

  Future<void> _initUser() async {
    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    final user = await getCurrentUser();
    if (user != null) {
      state = user;
    }
  }

  UserModel? get currentUser => state;
  bool get isLoggedIn => state != null;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    ref.notifyListeners();
    try {
      final login = ref.read(loginUseCaseProvider);
      state = await login(email: email, password: password);
    } finally {
      _isLoading = false;
      ref.notifyListeners();
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    _isLoading = true;
    ref.notifyListeners();
    try {
      final register = ref.read(registerUseCaseProvider);
      state = await register(
        email: email,
        password: password,
        name: name ?? "",
      );
    } finally {
      _isLoading = false;
      ref.notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    // This logic should be expanded to use a GoogleSignInUseCase
  }

  Future<void> signOut() async {
    final logout = ref.read(logoutUseCaseProvider);
    await logout();
    state = null;
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    if (state == null) return;

    _isLoading = true;
    ref.notifyListeners();
    try {
      final updateProfile = ref.read(updateProfileUseCaseProvider);
      state = await updateProfile(
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
      );
    } finally {
      _isLoading = false;
      ref.notifyListeners();
    }
  }
}
