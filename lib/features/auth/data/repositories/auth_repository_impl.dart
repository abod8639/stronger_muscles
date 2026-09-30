import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_service.dart';
import 'package:stronger_muscles/features/auth/data/mappers/user_mapper.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<UserEntity?> getCurrentUser() async {
    final model = await authService.getCurrentUser();
    return model?.toEntity();
  }

  @override
  Future<UserEntity> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    final model = await authService.googleSignIn(
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
    return model.toEntity();
  }

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final model = await authService.login(email: email, password: password);
    return model.toEntity();
  }

  @override
  Future<void> logout() {
    return authService.logout();
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final model = await authService.register(name: name, email: email, password: password);
    return model.toEntity();
  }

  @override
  Future<UserEntity> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    final model = await authService.updateProfile(
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );
    return model.toEntity();
  }
}
