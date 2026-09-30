import 'package:flutter_test/flutter_test.dart';
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

  @override
  Future<UserEntity> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    lastGoogleEmail = email;
    lastGoogleName = name;
    lastGooglePhotoUrl = photoUrl;
    return UserEntity(
      id: 5,
      email: email,
      name: name,
      token: "testToken"
    );
  }

  @override
  Future<UserEntity> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    lastUpdatedName = name;
    lastUpdatedEmail = email;
    lastUpdatedPhone = phone;
    lastUpdatedPhotoUrl = photoUrl;
    return UserEntity(
      id: 5,
      email: email ?? 'orig@test.com',
      name: name ?? 'Original Name',
      phone: phone,
      token: "testToken",
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<UserEntity> login({required String email, required String password}) async =>
      throw UnimplementedError();

  @override
  Future<void> logout() async {}

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
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
    test('GoogleSignInUseCase invokes repository with proper arguments', () async {
      final useCase = GoogleSignInUseCase(mockRepo);

      final user = await useCase(
        email: 'google_user@gmail.com',
        name: 'Google User',
        photoUrl: 'https://lh3.googleusercontent.com/photo.png',
      );

      expect(user.id, 5);
      expect(mockRepo.lastGoogleEmail, 'google_user@gmail.com');
      expect(mockRepo.lastGoogleName, 'Google User');
      expect(mockRepo.lastGooglePhotoUrl, 'https://lh3.googleusercontent.com/photo.png');
    });

    test('UpdateProfileUseCase delegates updated parameters to repository', () async {
      final useCase = UpdateProfileUseCase(mockRepo);

      final updatedUser = await useCase(
        name: 'New Name',
        phone: '+966500000000',
      );

      expect(updatedUser.name, 'New Name');
      expect(mockRepo.lastUpdatedName, 'New Name');
      expect(mockRepo.lastUpdatedPhone, '+966500000000');
    });
  });
}
