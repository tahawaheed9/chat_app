import 'package:chat_app/views/components/chat_bubble.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/controller/database_controller.dart';

class ChatView extends StatefulWidget {
  final String userId;
  final String username;

  const ChatView({super.key, required this.userId, required this.username});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController _chatController = ChatController();
  final AuthController _authController = AuthController();
  final DatabaseController _dbController = DatabaseController();

  @override
  void dispose() {
    _chatController.message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final senderId = _authController.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 5.0),
            Text(widget.username),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: _dbController.getMessages(senderId, widget.userId),
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
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['sender-id'] == _authController.currentUser!.uid;

    final alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: <Widget>[
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
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
              controller: _chatController.message,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.chat_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_chatController.message.text.isNotEmpty) {
                await _chatController.sendMessage(
                  widget.userId,
                  _chatController.message.text.trim(),
                );
                _chatController.message.clear();
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
