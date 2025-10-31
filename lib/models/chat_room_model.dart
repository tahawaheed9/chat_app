import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String chatRoomId;
  final List<String> userIds;
  final String lastMessage;
  final DateTime timestamp;

  ChatRoomModel({
    required this.chatRoomId,
    required this.userIds,
    required this.lastMessage,
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

  factory ChatRoomModel.fromJson(DocumentSnapshot doc) {
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

    return ChatRoomModel(
      chatRoomId: doc.id,
      userIds: (json['user-ids'] as List<dynamic>)
          .map((id) => id as String)
          .toList(),
      lastMessage: json['last-message'] as String? ?? '',
      timestamp: messageTime,
    );
  }

  Map<String, dynamic> toJson() {
    final List<String> sortedUserIds = userIds..sort();
    return {
      'user-ids': sortedUserIds,
      'last-message': lastMessage,
      'timestamp': timestamp,
    };
  }
}
