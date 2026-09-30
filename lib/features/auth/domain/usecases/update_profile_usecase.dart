import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserEntity> call({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    return repository.updateProfile(
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );
  }
}
