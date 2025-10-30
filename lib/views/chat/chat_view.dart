import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/views/components/chat_bubble.dart';
import 'package:chat_app/controller/database_controller.dart';

class ChatView extends StatefulWidget {
  final String receiverUserId;
  final String receiverUsername;

  const ChatView({
    super.key,
    required this.receiverUserId,
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
    final senderId = _auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 5.0),
            Text(widget.receiverUsername),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: _db.getMessages(senderId, widget.receiverUserId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
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
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

    MessageModel messageData = MessageModel.fromJson(json);

    bool isCurrentUser = messageData.senderId == _auth.currentUser!.uid;

    final alignment = isCurrentUser
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
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.chat_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_message.text.isNotEmpty) {
                final String message = _message.text.trim();

                await _chat.sendMessage(
                  receiverId: widget.receiverUserId,
                  message: message,
                );

                _message.clear();
                return;
              }
            },
            icon: const Icon(Icons.send_outlined),
          ),
        ],
      ),
    );
  }
}
