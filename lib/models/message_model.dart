class MessageModel {
  final String senderId;
  final String senderUsername;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.senderId,
    required this.senderUsername,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
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

    return MessageModel(
      // Cast the values to the expected type
      senderId: json['sender-id'] as String? ?? '',
      senderUsername: json['sender-username'] as String? ?? '',
      receiverId: json['receiver-id'] as String? ?? '',
      message: json['message'] as String? ?? '',
      timestamp: messageTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender-id': senderId,
      'sender-username': senderUsername,
      'receiver-id': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
