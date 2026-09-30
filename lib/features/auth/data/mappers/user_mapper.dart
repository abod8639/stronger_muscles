import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

/// Maps between data layer [UserModel] and domain layer [UserEntity].
extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      token: token ?? '',
    );
  }
}
