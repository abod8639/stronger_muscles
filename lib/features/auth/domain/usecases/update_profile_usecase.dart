import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

/// Pure Dart usecase for updating profile details.
class UpdateProfileUseCase {
  final AuthRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    return _repository.updateProfile(
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );
  }
}
