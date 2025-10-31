import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';

class DatabaseController extends GetxController {
  late final FirebaseFirestore _db;
  late final AuthController _auth;

  static const String _userCollection = 'users';
  static const String _chatRoomCollection = 'chat-rooms';
  static const String _messagesCollection = 'messages';

  late final CollectionReference _userCollRef;
  late final CollectionReference _chatRoomCollRef;

  DatabaseController() {
    _db = FirebaseFirestore.instance;
    _auth = Get.find<AuthController>();
    _userCollRef = _db.collection(_userCollection);
    _chatRoomCollRef = _db.collection(_chatRoomCollection);
  }

  /// ----- USER RELATED CODE -----

  // Creating the user profile...
  Future<void> setUserData({required UserModel userData}) async {
    try {
      await _userCollRef.doc(userData.userId).set(userData.toJson());
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  // Getting the current user information...
  Future<UserModel> getCurrentUser({required String userId}) async {
    try {
      final docSnapshot = await _userCollRef.doc(userId).get();
      if (!docSnapshot.exists) {
        throw Exception(AppTextStrings.onNoUserFound);
      }
      return UserModel.fromJson(docSnapshot);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  // Fetching all the users from the firestore except, current...
  Stream<List<DocumentSnapshot>> getAllUsers() {
    try {
      return _userCollRef
          .orderBy('username', descending: false)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.where((doc) {
              return doc.id != _auth.currentUser!.uid;
            }).toList();
          });
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  /// ----- CHAT ROOM RELATED CODE -----

  // Getting all the chat rooms...
  Stream<List<ChatRoomModel>> getChatRooms({required String userId}) {
    try {
      return _chatRoomCollRef
          .orderBy('timestamp', descending: true)
          .where('user-ids', arrayContains: userId)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return ChatRoomModel.fromJson(doc);
            }).toList();
          });
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  // Creating or updating the a chat-room...
  Future<void> createOrUpdateChatRoom({
    required ChatRoomModel chatRoomData,
    required MessageModel messageData,
  }) async {
    try {
      final List<String> sortedUserIds = chatRoomData.userIds..sort();
      // Check if the chat-room exists...
      final QuerySnapshot query = await _chatRoomCollRef
          .where('user-ids', isEqualTo: sortedUserIds)
          .get();

      // If chat-room exists...
      if (query.docs.isNotEmpty) {
        // Updating the existing chat-room...
        final chatRoomId = query.docs.first.id;

        final Map<String, dynamic> chatRoomUpdates = {
          'last-message': chatRoomData.lastMessage,
          'timestamp': chatRoomData.timestamp,
        };

        await _chatRoomCollRef
            .doc(chatRoomId)
            .update(chatRoomUpdates)
            .whenComplete(() async {
              await _chatRoomCollRef
                  .doc(chatRoomId)
                  .collection(_messagesCollection)
                  .add(messageData.toJson());
            });
        return;
      }

      // Otherwise, if the chat-room does not exists. create a new...
      final DocumentReference newDoc = await _chatRoomCollRef.add(
        chatRoomData.toJson(),
      );

      final String chatRoomId = newDoc.id;

      await _chatRoomCollRef
          .doc(chatRoomId)
          .collection(_messagesCollection)
          .add(messageData.toJson());

      return;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  // Getting all the chat messages for a specific chat-room...
  Stream<QuerySnapshot> getConversation({
    required List<String> userIds,
  }) async* {
    try {
      final List<String> sortedUserIds = userIds..sort();

      final QuerySnapshot query = await _chatRoomCollRef
          .where('user-ids', isEqualTo: sortedUserIds)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final String chatRoomId = query.docs.first.id;

        yield* _chatRoomCollRef
            .doc(chatRoomId)
            .collection(_messagesCollection)
            .orderBy('timestamp', descending: false)
            .snapshots();
      }
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
