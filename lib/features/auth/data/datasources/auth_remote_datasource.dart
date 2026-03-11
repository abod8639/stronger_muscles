import '../models/auth_model.dart';

abstract class AuthRemoteDatasource {
  Future<List<AuthModel>> getAllAuths();
  Future<AuthModel> getAuthById(String id);
  Future<void> createAuth(AuthModel model);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  // TODO: inject Dio / http client

  @override
  Future<List<AuthModel>> getAllAuths() async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<AuthModel> getAuthById(String id) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> createAuth(AuthModel model) async {
    // TODO: implement API call
    throw UnimplementedError();
  }
}
