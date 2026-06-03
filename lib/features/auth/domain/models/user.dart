import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.createdAt,
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  @override
  List<Object?> get props => [id, email, name, avatarUrl, createdAt];
}
