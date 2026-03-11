import '../models/profile_model.dart';

abstract class ProfileLocalDatasource {
  Future<List<ProfileModel>> getCachedProfiles();
  Future<void> cacheProfiles(List<ProfileModel> models);
}

class ProfileLocalDatasourceImpl implements ProfileLocalDatasource {
  // TODO: inject SharedPreferences / Hive / Isar

  @override
  Future<List<ProfileModel>> getCachedProfiles() async {
    // TODO: implement local read
    throw UnimplementedError();
  }

  @override
  Future<void> cacheProfiles(List<ProfileModel> models) async {
    // TODO: implement local write
    throw UnimplementedError();
  }
}
