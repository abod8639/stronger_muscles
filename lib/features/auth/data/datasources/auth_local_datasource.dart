import '../models/auth_model.dart';

abstract class AuthLocalDatasource {
  Future<List<AuthModel>> getCachedAuths();
  Future<void> cacheAuths(List<AuthModel> models);
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  // TODO: inject SharedPreferences / Hive / Isar

  @override
  Future<List<AuthModel>> getCachedAuths() async {
    // TODO: implement local read
    throw UnimplementedError();
  }

  @override
  Future<void> cacheAuths(List<AuthModel> models) async {
    // TODO: implement local write
    throw UnimplementedError();
  }
}
