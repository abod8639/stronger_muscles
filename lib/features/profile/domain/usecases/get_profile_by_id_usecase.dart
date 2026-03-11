import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileByIdUsecase {
  final ProfileRepository repository;

  GetProfileByIdUsecase(this.repository);

  Future<ProfileEntity> call(String id) => repository.getProfileById(id);
}
