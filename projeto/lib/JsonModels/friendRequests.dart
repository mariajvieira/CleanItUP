import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendRequestsPage extends StatefulWidget {
  final String currentUserId;

  FriendRequestsPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to send friend requests
  void sendFriendRequest(String receiverId) async {
    await _firestore.collection('friendRequests').add({
      'senderId': widget.currentUserId,
      'receiverId': receiverId,
      'status': 'pending'
    });
  }

  // Method to accept friend requests
  void acceptFriendRequest(String requestId, String senderId) async {
    await _firestore.collection('friendRequests').doc(requestId).update({
      'status': 'accepted'
    });

    // Also add both users to each other's friends list
    await _firestore.collection('friends').add({
      'user1Id': widget.currentUserId,
      'user2Id': senderId
    });
    await _firestore.collection('friends').add({
      'user1Id': senderId,
      'user2Id': widget.currentUserId
    });
  }

  // Stream to get incoming friend requests
  Stream<List<FriendRequest>> getIncomingFriendRequests() {
    return _firestore.collection('friendRequests')
        .where('receiverId', isEqualTo: widget.currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => FriendRequest.fromFirestore(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: StreamBuilder<List<FriendRequest>>(
        stream: getIncomingFriendRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(requests[index].senderId), // Ideally, fetch and show user name
                  subtitle: Text('Tap to accept'),
                  onTap: () => acceptFriendRequest(requests[index].id, requests[index].senderId),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error loading requests');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class FriendRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  factory FriendRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FriendRequest(
      id: doc.id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      status: data['status'],
    );
  }
}
