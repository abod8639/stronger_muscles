import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class GetAuthByIdUsecase {
  final AuthRepository repository;

  GetAuthByIdUsecase(this.repository);

  Future<AuthEntity> call(String id) => repository.getAuthById(id);
}
