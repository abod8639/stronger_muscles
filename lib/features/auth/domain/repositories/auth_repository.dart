import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
  });
  Future<UserEntity> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  });
}
