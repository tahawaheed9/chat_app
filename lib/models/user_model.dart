class UserModel {
  final String userId;
  final String username;
  final String email;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user-id'] as String? ?? '',
      username: map['username'] as String? ?? '',
      email: map['email-address'] as String? ?? '',
    );
  }

  Map<String, Object> toJson() {
    return {'user-id': userId, 'username': username, 'email-address': email};
  }
}
