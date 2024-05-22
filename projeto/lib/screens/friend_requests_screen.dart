import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestsScreen extends StatefulWidget {
  final VoidCallback onFriendRequestAccepted;

  const FriendRequestsScreen({Key? key, required this.onFriendRequestAccepted}) : super(key: key);

  @override
  _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  List<Map<String, dynamic>> friendRequests = [];

  @override
  void initState() {
    super.initState();
    fetchFriendRequests();
  }

  void fetchFriendRequests() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      var requestsSnapshot = await FirebaseFirestore.instance
          .collection('friendRequests')
          .where('receiverId', isEqualTo: uid)
          .where('status', isEqualTo: 'pending')
          .get();

      var allRequests = requestsSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc.data()['senderName'],
          'senderId': doc.data()['senderId']
        };
      }).toList();

      setState(() {
        friendRequests = allRequests;
      });
    } catch (e) {
      print('Error fetching friend requests: $e');
    }
  }

  void acceptFriendRequest(String docId, String senderId) async {
    try {
      await FirebaseFirestore.instance.collection('friendRequests').doc(docId).update({
        'status': 'accepted'
      });

      var batch = FirebaseFirestore.instance.batch();
      var currentUser = FirebaseAuth.instance.currentUser!.uid;

      var friendDoc = await FirebaseFirestore.instance.collection('users').doc(senderId).get();
      var friendData = friendDoc.data();
      var friendName = (friendData?['firstName'] ?? 'Unknown') + ' ' + (friendData?['lastName'] ?? '');
      var friendEmail = friendData?['email'] ?? 'Unknown';

      var currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser).get();
      var currentUserData = currentUserDoc.data();
      var currentUserName = (currentUserData?['firstName'] ?? 'Unknown') + ' ' + (currentUserData?['lastName'] ?? '');
      var currentUserEmail = currentUserData?['email'] ?? 'Unknown';

      batch.set(
        FirebaseFirestore.instance.collection('friends').doc(),
        {'userId': currentUser, 'friendId': senderId, 'name': friendName, 'email': friendEmail},
      );
      batch.set(
        FirebaseFirestore.instance.collection('friends').doc(),
        {'userId': senderId, 'friendId': currentUser, 'name': currentUserName, 'email': currentUserEmail},
      );

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request accepted!')),
      );

      setState(() {
        friendRequests.removeWhere((request) => request['id'] == docId);
      });

      widget.onFriendRequestAccepted();
    } catch (e) {
      print('Error handling friend request: $e');
    }
  }

  void rejectFriendRequest(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('friendRequests').doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request rejected')),
      );

      setState(() {
        friendRequests.removeWhere((request) => request['id'] == docId);
      });
    } catch (e) {
      print('Error rejecting friend request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: friendRequests.length,
        itemBuilder: (context, index) {
          var request = friendRequests[index];
          return ListTile(
            title: Text(request['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => acceptFriendRequest(request['id'], request['senderId']),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () => rejectFriendRequest(request['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
