import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
  });
  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  });
}
