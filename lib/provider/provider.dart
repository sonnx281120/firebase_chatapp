import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  String _receiverEmail = "";

  String get receiverEmail => _receiverEmail;

  void setReceiverEmail(String email) {
    _receiverEmail = email;
    notifyListeners();
  }
}
