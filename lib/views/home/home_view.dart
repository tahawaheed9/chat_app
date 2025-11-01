import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/views/chat/chat_view.dart';
import 'package:chat_app/utils/constants/routes.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/utils/helpers/helper_functions.dart';
import 'package:chat_app/controller/database_controller.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AuthController _auth;
  late final DatabaseController _db;

  late final String senderUserId;

  @override
  void initState() {
    super.initState();

    _auth = Get.find<AuthController>();
    _db = Get.find<DatabaseController>();

    senderUserId = _auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.newChatRoute),
        icon: const Icon(Icons.chat_outlined),
        label: const Text(AppTextStrings.newChatButtonText),
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: _db.getChatRooms(userId: senderUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return HelperFunctions.showErrorWidget(
              error: snapshot.error.toString(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return HelperFunctions.showLoadingWidget(
              loadingText: AppTextStrings.onFetchingChatRoom,
            );
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

              final String receiverUserId = chatRoomData.userIds
                  .where((id) => id != senderUserId)
                  .first;

              return FutureBuilder(
                future: _db.getUserData(userId: receiverUserId),
                builder: (context, snapshot) {
                  String receiverUsername =
                      AppTextStrings.onFetchingReceiverUsername;

                  VoidCallback? onTap;

                  if (snapshot.hasData) {
                    final UserModel receiverUserData = snapshot.data!;
                    receiverUsername = receiverUserData.username;

                    // Defining the onTap method when the data has been received
                    // to ensure the user does not navigates to the next page
                    // until the data is completed loaded.

                    onTap = () {
                      Get.to(ChatView(userIds: chatRoomData.userIds));
                    };
                  }

                  return ListTile(
                    leading: HelperFunctions.showAvatarWidget(),
                    title: Text(
                      receiverUsername,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      chatRoomData.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(chatRoomData.readableTime),
                    onTap: onTap,
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
