import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;
  final ProfileLocalDatasource localDatasource;

  ProfileRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<ProfileEntity>> getAllProfiles() async {
    final models = await remoteDatasource.getAllProfiles();
    await localDatasource.cacheProfiles(models);
    return models;
  }

  @override
  Future<ProfileEntity> getProfileById(String id) =>
      remoteDatasource.getProfileById(id);

  @override
  Future<void> createProfile(ProfileEntity entity) =>
      remoteDatasource.createProfile(ProfileModel(id: entity.id, name: entity.name));
}
