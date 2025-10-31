import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/chat_room_model.dart';
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
    required String chatRoomId,
    required String lastMessage,
  }) async {
    final String senderId = _auth.currentUser!.uid;

    final UserModel userData = await _db.getCurrentUser(userId: senderId);

    final String senderUsername = userData.username;
    final DateTime timestamp = Timestamp.now().toDate();

    // Adding new message to the database...
    // await _db.createOrUpdateChatRoom(chatRoomData: chatRoomData);
  }
}
