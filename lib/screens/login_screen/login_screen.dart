import 'package:firebase_chatapp/components/my_button.dart';
import 'package:firebase_chatapp/components/my_textfield.dart';
import 'package:firebase_chatapp/constant/app_router_enum.dart';
import 'package:firebase_chatapp/router/navigator_service.dart';
import 'package:firebase_chatapp/screens/login_screen/login_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LoginScreenProvider(), child: _ContentWidget());
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget();

  @override
  Widget build(BuildContext context) {
    final provider = LoginScreenProvider.of(context);
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
              "Welcome back, you've been missed!",
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
            const SizedBox(height: 25),
            MyButton(text: "Login", onTap: provider.login),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Now a member?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: () {
                    NavigatorService.navigateTo(AppRoutes.register.path);
                  },
                  child: Text(
                    "Register now",
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
