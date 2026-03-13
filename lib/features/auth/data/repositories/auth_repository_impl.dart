import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_service.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

part 'auth_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<UserModel?> getCurrentUser() {
    return authService.getCurrentUser();
  }

  @override
  Future<UserModel> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
  }) {
    return authService.googleSignIn(
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }

  @override
  Future<UserModel> login({required String email, required String password}) {
    return authService.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return authService.logout();
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) {
    return authService.register(name: name, email: email, password: password);
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    return authService.updateProfile(
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );
  }
}
