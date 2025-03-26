import 'package:firebase_chatapp/router/navigator_service.dart';
import 'package:flutter/material.dart';

Future<void> showMyDialog(String messageText, bool isSuccess) async {
  if (NavigatorService.currentContext != null) {
    await showDialog(
      barrierDismissible: false,
      context: NavigatorService.currentContext!,
      builder: (_) {
        Future.delayed(const Duration(seconds: 2), () {
          NavigatorService.pop();
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(children: [
            Icon(isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red),
            const SizedBox(width: 10),
            Text(isSuccess ? 'Successfull' : 'Error',
                style: TextStyle(color: isSuccess ? Colors.green : Colors.red)),
          ]),
          content: Text(messageText),
        );
      },
    );
  }
}
