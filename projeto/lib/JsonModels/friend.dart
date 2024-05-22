import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String id;
  final String name;
  final String email;

  Friend({required this.id, required this.name, required this.email});

  factory Friend.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Friend(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      email: data['email'] ?? 'Unknown',
    );
  }
}
