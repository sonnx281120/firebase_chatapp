import 'dart:async';
import 'dart:io';
import 'package:firebase_chatapp/services/auth/auth_service.dart';
import 'package:firebase_chatapp/services/chat/chat_service.dart';
import 'package:firebase_chatapp/services/upload/upload_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChangeScreenProvider extends ChangeNotifier {
  final String email;
  final String uid;
  Timer? _debounceTimer;
  final TextEditingController messageController = TextEditingController();
  final ValueNotifier<List<File?>> _selectedImages =
      ValueNotifier<List<File?>>([]);
  ValueListenable<List<File?>> get selectedImages => _selectedImages;

  final ScrollController scrollController = ScrollController();

  factory ChangeScreenProvider.of(BuildContext context) => context.read();

  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();

  ChangeScreenProvider({required this.email, required this.uid}) {
    messageController.addListener(checkInputNotEmpty);
  }

  void removeImage(int index) {
    final newList = List<File?>.from(_selectedImages.value);
    newList.removeAt(index);
    _selectedImages.value = newList;
    if (_selectedImages.value.isEmpty) {
      chatService.updateTypingStatus(uid, false);
    }
    notifyListeners();
  }

  void clearListImages() {
    _selectedImages.value = [];
    chatService.updateTypingStatus(uid, false);
    notifyListeners();
  }

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty || _selectedImages.value.isNotEmpty) {
      final listImageUrls = _selectedImages.value.isNotEmpty
          ? await UploadService.uploadImages(
              _selectedImages.value.whereType<File>().toList())
          : null;
      chatService.sendMessage(uid, messageController.text,
          listImageUrls: listImageUrls ?? []);
      messageController.clear();
      clearListImages();
      Future.delayed(Duration(milliseconds: 300), () {
        scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void checkInputNotEmpty() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (messageController.text.isNotEmpty) {
      _debounceTimer = Timer(Duration(seconds: 1), () {
        chatService.updateTypingStatus(uid, true);
      });
    } else {
      chatService.updateTypingStatus(uid, false);
    }
  }

  Future<void> pickImages() async {
    final List<XFile> listImages = await ImagePicker().pickMultiImage();
    if (listImages.isNotEmpty) {
      final newList = List<File?>.from(_selectedImages.value)
        ..addAll(listImages.map((image) => File(image.path)));

      _selectedImages.value = newList;

      chatService.updateTypingStatus(uid, true);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    messageController.removeListener(checkInputNotEmpty);
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
