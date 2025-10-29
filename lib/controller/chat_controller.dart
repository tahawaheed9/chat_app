import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/controller/database_controller.dart';

import 'package:chat_app/controller/auth_controller.dart';

class ChatController extends GetxController {
  final TextEditingController message = TextEditingController();

  final AuthController _authController = AuthController();
  final DatabaseController _dbController = DatabaseController();

  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = _authController.currentUser!.uid;
    final String? currentUserEmail = _authController.currentUser?.email;
    final Timestamp timestamp = Timestamp.now();

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
    await _dbController.createChatRoom(chatRoomId, newMessage);
  }
}
