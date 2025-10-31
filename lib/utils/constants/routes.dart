import 'package:get/get.dart';

import 'package:chat_app/views/home/home_view.dart';
import 'package:chat_app/views/login/login_view.dart';
import 'package:chat_app/views/contacts/contacts_view.dart';
import 'package:chat_app/views/register/register_view.dart';

class Routes {
  Routes._();

  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String newChatRoute = '/contacts';

  static const String initialRoute = loginRoute;

  static List<GetPage> getPages = [
    GetPage(name: loginRoute, page: () => const LoginView()),
    GetPage(name: registerRoute, page: () => const RegisterView()),
    GetPage(name: homeRoute, page: () => const HomeView()),
    GetPage(name: newChatRoute, page: () => const ContactsView()),
  ];
}
