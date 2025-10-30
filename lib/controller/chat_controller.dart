import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/database_controller.dart';

class ChatController extends GetxController {
  late final AuthController _auth;
  late final DatabaseController _db;

  ChatController() {
    _auth = Get.find<AuthController>();
    _db = Get.find<DatabaseController>();
  }

  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String? currentUserEmail = _auth.currentUser?.email;
    final DateTime timestamp = Timestamp.now().toDate();

    // New message...
    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      senderUsername: currentUserEmail!,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Creating a chat-room...
    List<String> userIds = [currentUserId, receiverId];
    userIds.sort();
    String chatRoomId = userIds.join('_');

    // Adding new message to the database...
    await _db.createChatRoom(chatRoomId, newMessage);
  }
}
