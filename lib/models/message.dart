// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sendId;
  final String? sendEmail;
  final String receiverId;
  final String message;
  final List<String?> listImageUrls;
  final Timestamp timestamp;

  Message({
    required this.sendId,
    required this.sendEmail,
    required this.receiverId,
    required this.message,
    required this.listImageUrls,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sendId': sendId,
      'sendEmail': sendEmail,
      'receiverId': receiverId,
      'message': message,
      'listImageUrls': listImageUrls,
      'timestamp': timestamp,
    };
  }
}
