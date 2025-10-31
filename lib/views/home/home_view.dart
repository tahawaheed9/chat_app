import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:chat_app/views/chat/chat_view.dart';
import 'package:chat_app/utils/constants/routes.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/utils/helpers/helper_functions.dart';
import 'package:chat_app/controller/database_controller.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseController db = Get.find<DatabaseController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTextStrings.homeViewAppBarTitle),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final AuthController auth = Get.find<AuthController>();
              await auth.logoutUser();
              return;
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.newChatRoute),
        child: const Icon(Icons.chat_outlined),
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: db.getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return HelperFunctions.showErrorWidget(
              error: snapshot.error.toString(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return HelperFunctions.showLoadingWidget();
          }
          final chatRooms = snapshot.data;

          if (chatRooms == null || chatRooms.isEmpty) {
            return HelperFunctions.showErrorWidget(
              error: AppTextStrings.onNoChatFound,
            );
          }
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final ChatRoomModel chatRoomData = chatRooms[index];
              final String chatRoomId = chatRoomData.chatRoomId;
              final String receiverUsername = chatRoomData.receiverUsername;
              return ListTile(
                leading: HelperFunctions.showAvatarWidget(),
                title: Text(
                  chatRoomData.receiverUsername,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(chatRoomData.lastMessage),
                trailing: Text(chatRoomData.timestamp.toString()),
                onTap: () {
                  Get.to(
                    ChatView(
                      chatRoomId: chatRoomId,
                      senderId: null,
                      receiverId: null,
                      receiverUsername: receiverUsername,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
