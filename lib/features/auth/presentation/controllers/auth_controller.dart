import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_service.dart';
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
    
    // Initial check for user
    _initUser();
    return null;
  }

  Future<void> _initUser() async {
    final service = ref.read(authServiceProvider);
    final user = await service.getCurrentUser();
    if (user != null) {
      state = user;
    }
  }

  UserModel? get currentUser => state;
  bool get isLoggedIn => state != null;

  Future<void> signInWithEmail({required String email, required String password}) async {
    _isLoading = true;
    state = state;
    try {
      final service = ref.read(authServiceProvider);
      state = await service.login(email: email, password: password);
    } finally {
      _isLoading = false;
      ref.notifyListeners();
    }
  }

  Future<void> signUpWithEmail({required String email, required String password, String? name}) async {
    _isLoading = true;
    state = state;
    try {
      final service = ref.read(authServiceProvider);
      state = await service.register(email: email, password: password, name: name ?? "");
    } finally {
      _isLoading = false;
      ref.notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    state = state;
    try {
      // Logic for Google SignIn would go here, then calling authService.googleSignIn
      // For now keeping it simple as it requires external setup
    } finally {
      _isLoading = false;
      ref.notifyListeners();
    }
  }

  Future<void> signOut() async {
    final service = ref.read(authServiceProvider);
    await service.logout();
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
      final service = ref.read(authServiceProvider);
      state = await service.updateProfile(
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
