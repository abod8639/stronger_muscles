import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfilesUsecase {
  final ProfileRepository repository;

  GetProfilesUsecase(this.repository);

  Future<List<ProfileEntity>> call() => repository.getAllProfiles();
}
