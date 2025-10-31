import 'package:get/get.dart';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/controller/database_controller.dart';

class ChatController extends GetxController {
  late final DatabaseController _db;

  ChatController() {
    _db = Get.find<DatabaseController>();
  }

  Future<void> sendMessage({
    required ChatRoomModel chatRoomData,
    required MessageModel messageData,
  }) async {
    await _db.createOrUpdateChatRoom(
      chatRoomData: chatRoomData,
      messageData: messageData,
    );
  }
}
