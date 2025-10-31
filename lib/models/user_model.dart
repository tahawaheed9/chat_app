import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String username;
  final String email;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;

    return UserModel(
      userId: doc.id,
      username: json['username'] as String? ?? '',
      email: json['email-address'] as String? ?? '',
    );
  }

  Map<String, Object> toJson() {
    return {'user-id': userId, 'username': username, 'email-address': email};
  }
}
