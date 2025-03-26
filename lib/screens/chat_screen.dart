import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chatapp/constant/app_router_enum.dart';
import 'package:firebase_chatapp/router/navigator_service.dart';
import 'package:firebase_chatapp/screens/chat_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> receiver =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (_) =>
          ChangeScreenProvider(email: receiver["email"], uid: receiver["uid"]),
      child: const _ContentWidget(),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget();

  @override
  Widget build(BuildContext context) {
    final provider = ChangeScreenProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.email),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(provider)),
          _buildTypingIndicator(provider),
          _buildMessageInput(provider),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ChangeScreenProvider provider) {
    return StreamBuilder<DocumentSnapshot>(
        stream: provider.chatService.getTypingStatus(provider.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data!.exists &&
              snapshot.data!.get(provider.uid) == true) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${provider.email} đang nhập...",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  Widget _buildMessageList(ChangeScreenProvider provider) {
    return StreamBuilder<QuerySnapshot>(
      stream: provider.chatService.getMessages(
          provider.authService.getCurrentUser()!.uid, provider.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Đã xảy ra lỗi khi tải tin nhắn"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Chưa có tin nhắn nào"));
        }

        final messages = snapshot.data!.docs;

        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: provider.scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(messages[index], provider);
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(
      DocumentSnapshot doc, ChangeScreenProvider provider) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isMe = data["sendId"] == provider.authService.getCurrentUser()!.uid;
    List<String> listImageUrls = List<String>.from(data["listImageUrls"] ?? []);
    String? messageText = data["message"];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (listImageUrls.isNotEmpty) _buildImageGallery(listImageUrls),
            if (messageText != null && messageText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  messageText,
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(List<String> listImageUrls) {
    return Column(
      children: [
        Wrap(
          spacing: 4,
          children: listImageUrls.map((url) {
            int index = listImageUrls.indexOf(url);
            return GestureDetector(
              onTap: () {
                NavigatorService.navigateTo(AppRoutes.imageDetail.path,
                    arguments: {
                      'listImageUrls': listImageUrls,
                      'index': index
                    });
              },
              child: CachedNetworkImage(
                imageUrl: url,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300], // Màu xám khi đang tải ảnh
                  child:
                      Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMessageInput(ChangeScreenProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
      child: Column(
        children: [
          ValueListenableBuilder<List<File?>>(
            valueListenable: provider.selectedImages,
            builder: (context, listImages, _) {
              if (listImages.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.file(
                            listImages[index]!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => provider.removeImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: provider.pickImages,
              ),
              Expanded(
                child: TextField(
                  controller: provider.messageController,
                  decoration: const InputDecoration(
                    hintText: "Nhập tin nhắn...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: provider.sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
