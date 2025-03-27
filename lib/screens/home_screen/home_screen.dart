import 'package:firebase_chatapp/constant/app_router_enum.dart';
import 'package:firebase_chatapp/router/navigator_service.dart';
import 'package:firebase_chatapp/screens/home_screen/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HomeScreenProvider(), child: _ContentWidget());
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget();

  @override
  Widget build(BuildContext context) {
    final provider = HomeScreenProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(provider),
    );
  }

  Widget _buildUserList(HomeScreenProvider provider) {
    return StreamBuilder(
        stream: provider.chatService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading ...");
          }

          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, provider))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, HomeScreenProvider provider) {
    if (userData["email"] != provider.authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData["email"],
          onTap: () {
            NavigatorService.navigateTo(AppRoutes.chat.path,
                arguments: userData);
          });
    } else {
      return Container();
    }
  }
}

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.text, required this.onTap});

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.person),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = HomeScreenProvider.of(context);
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              )),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    NavigatorService.pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text("S E T T I N G"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    NavigatorService.navigateTo(AppRoutes.settings.path);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: provider.logout,
            ),
          ),
        ],
      ),
    );
  }
}
