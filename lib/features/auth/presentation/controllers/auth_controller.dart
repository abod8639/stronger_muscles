import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  FutureOr<UserModel?> build() async {
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });

    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    return await getCurrentUser();
  }

  UserModel? get currentUser => state.value;
  bool get isLoggedIn => state.value != null;
  bool get isLoading => state.isLoading;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final login = ref.read(loginUseCaseProvider);
      return await login(email: email, password: password);
      
    });
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final register = ref.read(registerUseCaseProvider);
      return await register(email: email, password: password, name: name ?? "");
    });
  }

  Future<void> signInWithGoogle() async {
    // This logic should be expanded to use a GoogleSignInUseCase

  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final logout = ref.read(logoutUseCaseProvider);
      await logout();
      return null;
    });
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    if (state.value == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updateProfile = ref.read(updateProfileUseCaseProvider);
      return await updateProfile(
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
      );
    });
  }
}
