import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/views/chat/chat_view.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/database_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseController dbController = DatabaseController();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: <Widget>[
            Icon(Icons.chat_outlined),
            SizedBox(width: 5.0),
            Text('Chat'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final AuthController controller = AuthController();
              await controller.logoutUser();
              return;
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: dbController.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data;

          if (users == null || users.isEmpty) {
            return const Center(child: Text('No users found...'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> user = users[index];

              final UserModel userData = UserModel.fromJson(user);

              final String userId = userData.userId;
              final String username = userData.username;

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Get.to(ChatView(userId: userId, username: username));
                },
              );
            },
          );
        },
      ),
    );
  }
}
