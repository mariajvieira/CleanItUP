import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String status;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.status,
  });

  factory FriendRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FriendRequest(
      id: doc.id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      senderName: data['senderName'],
      status: data['status'],
    );
  }
}
