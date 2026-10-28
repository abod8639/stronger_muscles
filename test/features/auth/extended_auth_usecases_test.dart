import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/update_profile_usecase.dart';

class MockAuthRepository implements AuthRepository {
  String? lastGoogleEmail;
  String? lastGoogleName;
  String? lastGooglePhotoUrl;

  String? lastUpdatedName;
  String? lastUpdatedEmail;
  String? lastUpdatedPhone;
  String? lastUpdatedPhotoUrl;

  bool googleSignInCalled = false;

  @override
  Future<Either<Failure, UserEntity>> googleSignIn() async {
    googleSignInCalled = true;
    return const Right(
      UserEntity(
        id: 5,
        email: "google_user@gmail.com",
        name: "Google User",
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
    lastUpdatedName = name;
    lastUpdatedEmail = email;
    lastUpdatedPhone = phone;
    lastUpdatedPhotoUrl = photoUrl;
    return Right(
      UserEntity(
        id: 5,
        email: email ?? 'orig@test.com',
        name: name ?? 'Original Name',
        phone: phone,
        token: "testToken",
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser({
    CancelToken? cancelToken,
  }) async =>
      const Right(null);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> logout({CancelToken? cancelToken}) async =>
      const Right(unit);

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async =>
      throw UnimplementedError();
}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  group('UserEntity Tests', () {
    test('instantiates and compares equality correctly', () {
      const entity1 = UserEntity(
        id: 1,
        name: 'Dexter',
        email: 'dexter@test.com',
        token: 'token_abc',
      );

      const entity2 = UserEntity(
        id: 1,
        name: 'Dexter',
        email: 'dexter@test.com',
        token: 'token_abc',
      );

      expect(entity1, equals(entity2));
      expect(entity1.token, 'token_abc');
    });
  });

  group('Extended Auth UseCases Tests', () {
    test('GoogleSignInUseCase invokes repository', () async {
      final useCase = GoogleSignInUseCase(mockRepo);

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) {
          expect(user.id, 5);
          expect(mockRepo.googleSignInCalled, isTrue);
        },
      );
    });

    test('UpdateProfileUseCase delegates updated parameters to repository', () async {
      final useCase = UpdateProfileUseCase(mockRepo);

      final result = await useCase(
        name: 'New Name',
        phone: '+966500000000',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (updatedUser) {
          expect(updatedUser.name, 'New Name');
          expect(mockRepo.lastUpdatedName, 'New Name');
          expect(mockRepo.lastUpdatedPhone, '+966500000000');
        },
      );
    });
  });
}
