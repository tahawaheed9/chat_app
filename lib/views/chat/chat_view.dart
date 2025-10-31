import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/views/components/chat_bubble.dart';
import 'package:chat_app/utils/helpers/helper_functions.dart';
import 'package:chat_app/controller/database_controller.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';

class ChatView extends StatefulWidget {
  final String? chatRoomId;
  final String? senderId;
  final String? receiverId;
  final String receiverUsername;

  const ChatView({
    super.key,
    required this.chatRoomId,
    required this.senderId,
    required this.receiverId,
    required this.receiverUsername,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final TextEditingController _message;

  late final ChatController _chat;
  late final AuthController _auth;
  late final DatabaseController _db;

  @override
  void initState() {
    super.initState();
    _message = TextEditingController();

    _chat = Get.find<ChatController>();
    _auth = Get.find<AuthController>();
    _db = Get.find<DatabaseController>();
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            HelperFunctions.showAvatarWidget(),
            const SizedBox(width: AppSizes.spaceBetweenAppBarItems),
            Text(widget.receiverUsername),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.chatRoomId != null
                    ? _db.getChatMessages(
                        chatRoomId: widget.chatRoomId,
                        senderId: null,
                        receiverId: null,
                      )
                    : _db.getChatMessages(
                        chatRoomId: null,
                        senderId: widget.senderId,
                        receiverId: widget.receiverId,
                      ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return HelperFunctions.showErrorWidget(
                      error: snapshot.error.toString(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return HelperFunctions.showLoadingWidget();
                  }

                  final messages = snapshot.data as Map<String, dynamic>?;

                  if (messages == null || messages.isEmpty) {
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
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(DocumentSnapshot doc) {
    final MessageModel messageData = MessageModel.fromJson(doc);

    final bool isCurrentUser = messageData.senderId == _auth.currentUser!.uid;

    final Alignment alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: <Widget>[
          ChatBubble(
            message: messageData.message,
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _message,
              expands: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.chat_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceBetweenItems),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: IconButton(
              onPressed: () async {
                if (_message.text.isNotEmpty) {
                  final String latestMessage = _message.text.trim();
                  final DateTime timestamp = Timestamp.now().toDate();

                  _message.clear();
                  return;
                }
              },
              icon: const Icon(Icons.send_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
