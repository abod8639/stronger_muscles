/// Data Transfer Object (DTO) for authentication responses.
///
/// Encapsulates JSON serialization and deserialization strictly within
/// the data layer, decoupled from domain entities and cross-feature models.
class UserModel {
  final int id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? phone;
  final String? token;
  final String? role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.phone,
    this.token,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      photoUrl: (json['photo_url'] ?? json['photoUrl'])?.toString(),
      phone: json['phone']?.toString(),
      token: json['token']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (phone != null) 'phone': phone,
      if (token != null) 'token': token,
      if (role != null) 'role': role,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? photoUrl,
    String? phone,
    String? token,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          photoUrl == other.photoUrl &&
          phone == other.phone &&
          token == other.token &&
          role == other.role;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      photoUrl.hashCode ^
      phone.hashCode ^
      token.hashCode ^
      role.hashCode;

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, name: $name, phone: $phone, photoUrl: $photoUrl, token: $token, role: $role)';
}
