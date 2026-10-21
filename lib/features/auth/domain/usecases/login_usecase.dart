import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    return repository.login(
      email: email,
      password: password,
      cancelToken: cancelToken,
    );
  }
}
