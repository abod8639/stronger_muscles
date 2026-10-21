import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/login_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/logout_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/register_usecase.dart';

class FakeAuthRepository implements AuthRepository {
  UserEntity? mockUser;
  bool shouldThrow = false;
  bool logoutCalled = false;
  String? lastLoginEmail;
  String? lastLoginPassword;
  String? lastRegisterName;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async {
    if (shouldThrow) {
      return const Left(AuthFailure(message: 'Invalid credentials'));
    }
    lastLoginEmail = email;
    lastLoginPassword = password;
    return Right(
      mockUser ??
          UserEntity(
            id: 1,
            email: email,
            name: 'Logged In User',
            token: "testToken",
          ),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async {
    if (shouldThrow) {
      return const Left(ServerFailure(message: 'Email already in use'));
    }
    lastRegisterName = name;
    return Right(
      UserEntity(
        id: 2,
        email: email,
        name: name,
        token: "testToken",
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> logout({CancelToken? cancelToken}) async {
    logoutCalled = true;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser({
    CancelToken? cancelToken,
  }) async {
    return Right(mockUser);
  }

  @override
  Future<Either<Failure, UserEntity>> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
    CancelToken? cancelToken,
  }) async {
    return Right(
      UserEntity(
        id: 3,
        email: email,
        name: name,
        photoUrl: photoUrl,
        token: "testToken",
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    CancelToken? cancelToken,
  }) async {
    return Right(
      UserEntity(
        id: 1,
        email: email ?? 'test@example.com',
        name: name ?? 'Updated',
        token: "testToken",
      ),
    );
  }
}

void main() {
  late FakeAuthRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeAuthRepository();
  });

  group('Auth Domain UseCases Tests', () {
    test('LoginUseCase delegates credentials to repository and returns user', () async {
      final loginUseCase = LoginUseCase(fakeRepository);

      final result = await loginUseCase(
        email: 'user@strongermuscles.com',
        password: 'password123',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected right but got $failure'),
        (user) {
          expect(user.email, 'user@strongermuscles.com');
          expect(fakeRepository.lastLoginEmail, 'user@strongermuscles.com');
          expect(fakeRepository.lastLoginPassword, 'password123');
        },
      );
    });

    test('LoginUseCase returns Left failure on error', () async {
      fakeRepository.shouldThrow = true;
      final loginUseCase = LoginUseCase(fakeRepository);

      final result = await loginUseCase(
        email: 'wrong@example.com',
        password: 'wrongpassword',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.toMessage(), 'Invalid credentials');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('RegisterUseCase passes correct registration parameters', () async {
      final registerUseCase = RegisterUseCase(fakeRepository);

      final result = await registerUseCase(
        name: 'Captain Muscle',
        email: 'captain@strongermuscles.com',
        password: 'secretPassword',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected right but got $failure'),
        (user) {
          expect(user.name, 'Captain Muscle');
          expect(fakeRepository.lastRegisterName, 'Captain Muscle');
        },
      );
    });

    test('LogoutUseCase invokes repository logout', () async {
      final logoutUseCase = LogoutUseCase(fakeRepository);

      final result = await logoutUseCase();

      expect(result.isRight(), isTrue);
      expect(fakeRepository.logoutCalled, isTrue);
    });

    test('GetCurrentUserUseCase returns current user or null', () async {
      final getCurrentUserUseCase = GetCurrentUserUseCase(fakeRepository);

      // When no user is logged in
      var result = await getCurrentUserUseCase();
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) => expect(user, isNull),
      );

      // When user is set
      fakeRepository.mockUser = const UserEntity(
        id: 99,
        email: 'active@example.com',
        name: 'Active User',
        token: "testToken",
      );

      result = await getCurrentUserUseCase();
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) {
          expect(user, isNotNull);
          expect(user!.id, 99);
          expect(user.email, 'active@example.com');
        },
      );
    });
  });
}
