import 'package:firebase_chatapp/components/my_dialog.dart';
import 'package:firebase_chatapp/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class LoginScreenProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginScreenProvider();

  factory LoginScreenProvider.of(BuildContext context) => context.read();

  Future<void> login() async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      showMyDialog(e.toString(), false);
    }
  }
}
