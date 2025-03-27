import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_service.dart';
import '../../services/chat/chat_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  HomeScreenProvider();

  void logout() {
    authService.signout();
  }

  factory HomeScreenProvider.of(BuildContext context) => context.read();
}
