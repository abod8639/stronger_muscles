import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String name,
    String? photoUrl,
    CancelToken? cancelToken,
  }) {
    return repository.googleSignIn(
      email: email,
      name: name,
      photoUrl: photoUrl,
      cancelToken: cancelToken,
    );
  }
}
