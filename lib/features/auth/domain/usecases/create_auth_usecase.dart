import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class CreateAuthUsecase {
  final AuthRepository repository;

  CreateAuthUsecase(this.repository);

  Future<void> call(AuthEntity entity) => repository.createAuth(entity);
}
