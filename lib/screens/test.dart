// Widget _buildTypingIndicator(ChangeScreenProvider provider) {
//   return StreamBuilder<DocumentSnapshot>(
//     stream: provider.chatService.getTypingStatus(provider.uid),
//     builder: (context, snapshot) {
//       if (snapshot.hasData &&
//           snapshot.data!.exists &&
//           snapshot.data!.get("typing") == true) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text("Đang nhập...",
//               style:
//                   TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
//         );
//       }
//       return SizedBox.shrink();
//     },
//   );
// }
