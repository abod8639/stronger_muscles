/// Pure Dart domain entity representing an authenticated user.
///
/// Contains zero imports from Flutter, Dio, or third-party storage libraries.
class UserEntity {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.token,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? token,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          photoUrl == other.photoUrl &&
          token == other.token;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      photoUrl.hashCode ^
      token.hashCode;

  @override
  String toString() =>
      'UserEntity(id: $id, name: $name, email: $email, phone: $phone, photoUrl: $photoUrl, token: $token)';
}
