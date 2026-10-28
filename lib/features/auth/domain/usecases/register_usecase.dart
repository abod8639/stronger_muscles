import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

/// Pure Dart usecase for user registration.
class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
