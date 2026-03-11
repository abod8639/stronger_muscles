import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class CreateProfileUsecase {
  final ProfileRepository repository;

  CreateProfileUsecase(this.repository);

  Future<void> call(ProfileEntity entity) => repository.createProfile(entity);
}
