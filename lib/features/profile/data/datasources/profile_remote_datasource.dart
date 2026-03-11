import '../models/profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<List<ProfileModel>> getAllProfiles();
  Future<ProfileModel> getProfileById(String id);
  Future<void> createProfile(ProfileModel model);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  // TODO: inject Dio / http client

  @override
  Future<List<ProfileModel>> getAllProfiles() async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<ProfileModel> getProfileById(String id) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> createProfile(ProfileModel model) async {
    // TODO: implement API call
    throw UnimplementedError();
  }
}
