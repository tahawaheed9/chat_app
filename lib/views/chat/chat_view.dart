import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/views/components/chat_bubble.dart';
import 'package:chat_app/utils/helpers/helper_functions.dart';
import 'package:chat_app/controller/database_controller.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';
import 'package:chat_app/views/chat/components/bottom_navigation_widget.dart';

class ChatView extends StatefulWidget {
  final List<String> userIds;

  const ChatView({super.key, required this.userIds});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final TextEditingController _message;

  late final ChatController _chat;
  late final AuthController _auth;
  late final DatabaseController _db;

  late final Future<void> _loadUserFuture;

  UserModel? _senderUserData;
  UserModel? _receiverUserData;

  @override
  void initState() {
    super.initState();

    _message = TextEditingController();

    _chat = Get.find<ChatController>();
    _auth = Get.find<AuthController>();
    _db = Get.find<DatabaseController>();

    _loadUserFuture = _loadUsersData();
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: HelperFunctions.showLoadingWidget(
              loadingText: AppTextStrings.onFetchingChatRoom,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                HelperFunctions.showAvatarWidget(),
                const SizedBox(width: AppSizes.spaceBetweenAppBarItems),
                Text(_receiverUserData!.username),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSizes.defaultPadding),
            child: StreamBuilder<QuerySnapshot>(
              stream: _db.getConversation(userIds: widget.userIds),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return HelperFunctions.showErrorWidget(
                    error: snapshot.error.toString(),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return HelperFunctions.showLoadingWidget(
                    loadingText: AppTextStrings.onLoadingConversation,
                  );
                }

                final QuerySnapshot? query = snapshot.data;
                final List<DocumentSnapshot>? docs = query?.docs;

                if (docs == null || docs.isEmpty) {
                  return HelperFunctions.showErrorWidget(
                    error: AppTextStrings.onEmptyChat,
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs
                      .map((doc) => _buildMessageBubble(doc))
                      .toList(),
                );
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationWidget(
            message: _message,
            onMessageEntered: _handleMessage,
            onSendButtonPressed: _onSendButtonPressed,
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(DocumentSnapshot doc) {
    final MessageModel messageData = MessageModel.fromJson(doc);

    final bool isCurrentUser = messageData.senderId == _senderUserData!.userId;

    final Alignment alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(
        message: messageData.message,
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  // Fetching the message from the BottomNavigationWidget...
  void _handleMessage(String message) {
    _message.text = message;
    return;
  }

  Future<void> _onSendButtonPressed() async {
    final String lastMessage = _message.text.trim();
    final DateTime timestamp = Timestamp.now().toDate();

    final ChatRoomModel chatRoomData = ChatRoomModel(
      chatRoomId: '',
      userIds: widget.userIds,
      lastMessage: lastMessage,
      timestamp: timestamp,
    );

    final MessageModel messageData = MessageModel(
      senderId: _senderUserData!.userId,
      senderUsername: _senderUserData!.username,
      receiverId: _receiverUserData!.userId,
      receiverUsername: _receiverUserData!.username,
      message: lastMessage,
      timestamp: timestamp,
    );

    _message.clear();

    await _chat.sendMessage(
      chatRoomData: chatRoomData,
      messageData: messageData,
    );
    return;
  }

  Future<void> _loadUsersData() async {
    final String senderId = _auth.currentUser!.uid;
    final String receiverId = widget.userIds
        .where((id) => id != senderId)
        .first;

    final UserModel senderUserData = await _db.getUserData(userId: senderId);
    final UserModel receiverUserData = await _db.getUserData(
      userId: receiverId,
    );

    if (mounted) {
      setState(() {
        _senderUserData = senderUserData;
        _receiverUserData = receiverUserData;
      });
    }
  }
}
