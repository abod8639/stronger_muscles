import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<List<AuthEntity>> getAllAuths();
  Future<AuthEntity> getAuthById(String id);
  Future<void> createAuth(AuthEntity entity);
}
