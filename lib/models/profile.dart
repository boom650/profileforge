import 'dart:convert';

/// Lightweight profile model used by early tests.
/// The production models live in `student_profile.dart` / `user_profile.dart`;
/// this minimal class exists so `test/unit/profile_test.dart` has a stable,
/// self-contained target with the {id, name, email} + copyWith + JSON API.
class Profile {
  final String id;
  final String name;
  final String email;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? email,
  }) =>
      Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          other.id == id &&
          other.name == name &&
          other.email == email;

  @override
  int get hashCode => Object.hash(id, name, email);
}
