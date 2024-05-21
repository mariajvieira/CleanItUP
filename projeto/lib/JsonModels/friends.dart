import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  final String currentUserId;

  FriendsPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendFriendRequest(String receiverId) async {
    await _firestore.collection('friendRequests').add({
      'senderId': widget.currentUserId,
      'receiverId': receiverId,
      'status': 'pending'
    });
  }

  void acceptFriendRequest(String requestId) async {
    await _firestore.collection('friendRequests').doc(requestId).update({
      'status': 'accepted'
    });

    await _firestore.collection('friends').add({
      'user1Id': widget.currentUserId,
      'user2Id': requestId
    });
  }

  Stream<List<FriendRequest>> getFriendRequests() {
    return _firestore.collection('friendRequests')
        .where('receiverId', isEqualTo: widget.currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => FriendRequest.fromFirestore(doc)).toList();
    });
  }

  Stream<List<UserFriend>> getFriends() {
    return _firestore.collection('friends')
        .where('user1Id', isEqualTo: widget.currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserFriend.fromFirestore(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<FriendRequest>>(
              stream: getFriendRequests(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final requests = snapshot.data!;
                  return ListView(
                    children: requests.map((request) => ListTile(
                      title: Text(request.senderId),
                      trailing: TextButton(
                        child: Text('Accept'),
                        onPressed: () => acceptFriendRequest(request.id),
                      ),
                    )).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading friend requests');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserFriend>>(
              stream: getFriends(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final friends = snapshot.data!;
                  return ListView(
                    children: friends.map((friend) => ListTile(
                      title: Text(friend.user2Id),
                    )).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading friends');
                }
                return CircularProgressIndicator();
              },
            ),
          )
        ],
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
    Map data = doc.data() as Map<String, dynamic>;
    return FriendRequest(
      id: doc.id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      status: data['status'],
    );
  }
}

class UserFriend {
  final String id;
  final String user1Id;
  final String user2Id;

  UserFriend({
    required this.id,
    required this.user1Id,
    required this.user2Id,
  });

  factory UserFriend.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserFriend(
      id: doc.id,
      user1Id: data['user1Id'],
      user2Id: data['user2Id'],
    );
  }
}
