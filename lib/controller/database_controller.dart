import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/controller/auth_controller.dart';

class DatabaseController extends GetxController {
  late final FirebaseFirestore _db;
  late final AuthController _authController;

  static const String _userCollection = 'users';
  static const String _chatRoomCollection = 'chat-rooms';
  static const String _messagesCollection = 'messages';

  late final CollectionReference _userCollRef;
  late final CollectionReference _chatRoomCollRef;

  DatabaseController() {
    _db = FirebaseFirestore.instance;
    _authController = AuthController();
    _userCollRef = _db.collection(_userCollection);
    _chatRoomCollRef = _db.collection(_chatRoomCollection);
  }

  // Creating the user profile...
  Future<void> createUserData(UserModel userData) async {
    try {
      await _userCollRef.doc(userData.userId).set(userData.toJson());
    } catch (error) {
      debugPrint(error.toString());
      return;
    }
  }

  // Fetching all the users from the cloud...
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _userCollRef.snapshots().map((snapshot) {
      final allUsers = snapshot.docs.map((doc) {
        final user = doc.data() as Map<String, dynamic>;
        return user;
      }).toList();

      final filteredUsers = allUsers.where((userMap) {

        final String? userId = userMap['user-id'] as String?;


        return userId != null && userId != _authController.currentUser!.uid;
      }).toList();

      // 3. Return the filtered list
      return filteredUsers;
    });
  }

  // Creating a new chat-room...
  Future<void> createChatRoom(
    String chatRoomId,
    MessageModel newMessage,
  ) async {
    try {
      await _chatRoomCollRef
          .doc(chatRoomId)
          .collection(_messagesCollection)
          .add(newMessage.toJson());
    } catch (error) {
      debugPrint(error.toString());
      return;
    }
  }

  // Getting chats from chat-room...
  Stream<QuerySnapshot> getMessages(String userId, String receiverId) {
    List<String> userIds = [userId, receiverId];
    userIds.sort();
    String chatRoomId = userIds.join('_');

    return _chatRoomCollRef
        .doc(chatRoomId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
