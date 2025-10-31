import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String chatRoomId;
  final String senderId;
  final String receiverId;
  final String receiverUsername;
  final String lastMessage;
  final DateTime timestamp;

  ChatRoomModel({
    required this.chatRoomId,
    required this.senderId,
    required this.receiverId,
    required this.receiverUsername,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatRoomModel.fromJson(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    final timestampData = json['timestamp'];
    DateTime messageTime;

    if (timestampData is DateTime) {
      messageTime = timestampData;
    } else if (timestampData != null &&
        timestampData.runtimeType.toString().contains('Timestamp')) {
      messageTime = DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      messageTime = DateTime.fromMillisecondsSinceEpoch(0);
    }

    return ChatRoomModel(
      chatRoomId: doc.id,
      senderId: json['sender-id'] as String? ?? '',
      receiverId: json['receiver-id'] as String? ?? '',
      receiverUsername: json['receiver-username'] as String? ?? '',
      lastMessage: json['last-message'] as String? ?? '',
      timestamp: messageTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat-room-id': chatRoomId,
      'sender-id': senderId,
      'receiver-id': receiverId,
      'receiver-username': receiverUsername,
      'last-message': lastMessage,
      'timestamp': timestamp,
    };
  }
}
