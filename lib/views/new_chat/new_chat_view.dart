import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/views/chat/chat_view.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/database_controller.dart';
import 'package:chat_app/utils/helpers/helper_functions.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';

class NewChatView extends StatefulWidget {
  const NewChatView({super.key});

  @override
  State<NewChatView> createState() => _NewChatViewState();
}

class _NewChatViewState extends State<NewChatView> {
  late final AuthController _auth;
  late final DatabaseController _db;

  @override
  void initState() {
    super.initState();
    _auth = Get.find<AuthController>();
    _db = Get.find<DatabaseController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start a new conversation')),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _db.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return HelperFunctions.showLoadingWidget();
          }
          if (snapshot.hasError) {
            return HelperFunctions.showErrorWidget(
              error: snapshot.error.toString(),
            );
          }
          final List<DocumentSnapshot>? docs = snapshot.data;
          if (docs == null || docs.isEmpty) {
            return HelperFunctions.showErrorWidget(
              error: AppTextStrings.onNoUserFound,
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot docSnapshot = docs[index];

              final UserModel userData = UserModel.fromJson(docSnapshot);

              final String senderId = _auth.currentUser!.uid;
              final String receiverId = userData.userId;
              final String receiverUsername = userData.username;

              return ListTile(
                leading: HelperFunctions.showAvatarWidget(),
                title: Text(
                  receiverUsername,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Get.back();
                  Get.to(
                    ChatView(
                      chatRoomId: null,
                      senderId: senderId,
                      receiverId: receiverId,
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
