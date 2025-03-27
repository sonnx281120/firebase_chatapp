import 'package:firebase_chatapp/constant/app_router_enum.dart';
import 'package:firebase_chatapp/screens/chat_screen/chat_screen.dart';
import 'package:firebase_chatapp/screens/home_screen/home_screen.dart';
import 'package:firebase_chatapp/screens/image_detail_screen.dart';
import 'package:firebase_chatapp/screens/login_screen/login_screen.dart';
import 'package:firebase_chatapp/screens/register_screen/register_screen.dart';
import 'package:firebase_chatapp/screens/settings_screens.dart';
import 'package:firebase_chatapp/services/auth/auth_gate.dart';
import 'package:flutter/material.dart';

class RouterConfigApp {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.home.path: (context) => const HomeScreen(),
    AppRoutes.chat.path: (context) => const ChatScreen(),
    AppRoutes.register.path: (context) => const RegisterScreen(),
    AppRoutes.settings.path: (context) => const SettingsScreens(),
    AppRoutes.login.path: (context) => const LoginScreen(),
    AppRoutes.authGate.path: (context) => const AuthGate(),
    AppRoutes.imageDetail.path: (context) => const ImageDetailScreen()
  };
}
