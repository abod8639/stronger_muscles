import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Unit>> logout({CancelToken? cancelToken});

  Future<Either<Failure, UserEntity?>> getCurrentUser({CancelToken? cancelToken});

  Future<Either<Failure, UserEntity>> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    CancelToken? cancelToken,
  });
}
