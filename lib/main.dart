import 'package:flutter/material.dart';

import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chat_app/utils/constants/routes.dart';
import 'package:chat_app/views/login/login_view.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTextStrings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      home: const LoginView(),
    );
  }
}
