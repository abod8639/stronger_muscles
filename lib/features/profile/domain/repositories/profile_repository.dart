import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<List<ProfileEntity>> getAllProfiles();
  Future<ProfileEntity> getProfileById(String id);
  Future<void> createProfile(ProfileEntity entity);
}
