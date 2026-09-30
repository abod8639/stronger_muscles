import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String name,
    String? photoUrl,
  }) {
    return repository.googleSignIn(
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }
}
