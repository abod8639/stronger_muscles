import 'package:stronger_muscles/features/auth/data/models/user_model.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';

/// Extension mapper to convert [UserModel] DTO into [UserEntity] domain model.
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

/// Extension mapper to convert [UserEntity] domain model into [UserModel] DTO.
extension UserEntityMapper on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      token: token,
    );
  }
}
