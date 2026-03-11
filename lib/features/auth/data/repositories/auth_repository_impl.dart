import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<AuthEntity>> getAllAuths() async {
    final models = await remoteDatasource.getAllAuths();
    await localDatasource.cacheAuths(models);
    return models;
  }

  @override
  Future<AuthEntity> getAuthById(String id) =>
      remoteDatasource.getAuthById(id);

  @override
  Future<void> createAuth(AuthEntity entity) =>
      remoteDatasource.createAuth(AuthModel(id: entity.id, name: entity.name));
}
