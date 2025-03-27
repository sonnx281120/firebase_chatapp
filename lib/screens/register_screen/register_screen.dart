import 'package:firebase_chatapp/components/my_button.dart';
import 'package:firebase_chatapp/components/my_textfield.dart';
import 'package:firebase_chatapp/constant/app_router_enum.dart';
import 'package:firebase_chatapp/router/navigator_service.dart';
import 'package:firebase_chatapp/screens/register_screen/register_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RegisterScreenProvider(), child: _ContentWidget());
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget();

  @override
  Widget build(BuildContext context) {
    final provider = RegisterScreenProvider.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            Text(
              "Let's create account for you",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),
            const SizedBox(height: 25),
            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: provider.emailController,
            ),
            const SizedBox(height: 10),
            MyTextfield(
              hintText: "Password",
              obscureText: true,
              controller: provider.passwordController,
            ),
            const SizedBox(height: 10),
            MyTextfield(
              hintText: "Confirm Password",
              obscureText: true,
              controller: provider.confirmPasswordController,
            ),
            const SizedBox(height: 25),
            MyButton(text: "Register", onTap: provider.register),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: () {
                    NavigatorService.navigateTo(AppRoutes.login.path);
                  },
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
