import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? messageId;
  final String senderId;
  final String senderUsername;
  final String receiverId;
  final String receiverUsername;
  final String message;
  final DateTime timestamp;

  MessageModel({
    this.messageId,
    required this.senderId,
    required this.senderUsername,
    required this.receiverId,
    required this.receiverUsername,
    required this.message,
    required this.timestamp,
  });

  String get readableTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate.isAtSameMomentAs(today)) {
      return DateFormat.jm().format(timestamp);
    } else if (messageDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat.MMMd().format(timestamp);
    }
  }

  factory MessageModel.fromJson(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;

    final timestampData = json['timestamp'];
    DateTime messageTime;

    if (timestampData is Timestamp) {
      messageTime = timestampData.toDate();
    } else if (timestampData is DateTime) {
      messageTime = timestampData;
    } else {
      messageTime = DateTime.now();
    }

    return MessageModel(
      messageId: doc.id,
      senderId: json['sender-id'] as String? ?? '',
      senderUsername: json['sender-username'] as String? ?? '',
      receiverId: json['receiver-id'] as String? ?? '',
      receiverUsername: json['receiver-username'] as String? ?? '',
      message: json['message'] as String? ?? '',
      timestamp: messageTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender-id': senderId,
      'sender-username': senderUsername,
      'receiver-id': receiverId,
      'receiver-username': receiverUsername,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
