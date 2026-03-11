import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class GetAuthsUsecase {
  final AuthRepository repository;

  GetAuthsUsecase(this.repository);

  Future<List<AuthEntity>> call() => repository.getAllAuths();
}
