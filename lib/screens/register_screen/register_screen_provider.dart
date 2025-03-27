import 'package:firebase_chatapp/components/my_dialog.dart';
import 'package:firebase_chatapp/constant/app_router_enum.dart';
import 'package:firebase_chatapp/router/navigator_service.dart';
import 'package:firebase_chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreenProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final authService = AuthService();

  Future<void> register() async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await authService.signUpWithEmailPassword(
            emailController.text, passwordController.text);

        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        await showMyDialog("Register successful!", true);
        NavigatorService.navigateTo(AppRoutes.login.path);
      } catch (e) {
        showMyDialog(e.toString(), false);
      }
    } else {
      showMyDialog("Password don't mach!!", false);
    }
  }

  RegisterScreenProvider();
  factory RegisterScreenProvider.of(BuildContext context) => context.read();
}
