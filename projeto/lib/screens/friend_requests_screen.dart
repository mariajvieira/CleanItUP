import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestsScreen extends StatefulWidget {
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
          .where('to', isEqualTo: uid)
          .where('status', isEqualTo: 'pending')
          .get();

      var allRequests = requestsSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc.data()['fromName'], // Assuming 'fromName' holds the name of the requester
          'from': doc.data()['from'] // 'from' holds the uid of the requester
        };
      }).toList();

      setState(() {
        friendRequests = allRequests;
      });
    } catch (e) {
      print('Error fetching friend requests: $e');
    }
  }

  void acceptFriendRequest(String docId, String fromId) async {
    try {
      // Accept the friend request
      await FirebaseFirestore.instance.collection('friendRequests').doc(docId).update({
        'status': 'accepted'
      });

      // Add each other as friends in the users collection or a dedicated friends collection
      var batch = FirebaseFirestore.instance.batch();
      var currentUser = FirebaseAuth.instance.currentUser!.uid;

      batch.set(
        FirebaseFirestore.instance.collection('friends').doc(),
        {'userId': currentUser, 'friendId': fromId},
      );
      batch.set(
        FirebaseFirestore.instance.collection('friends').doc(),
        {'userId': fromId, 'friendId': currentUser},
      );

      await batch.commit();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request accepted!')),
      );

      // Remove from the list in the UI
      setState(() {
        friendRequests.removeWhere((request) => request['id'] == docId);
      });
    } catch (e) {
      print('Error handling friend request: $e');
    }
  }

  void rejectFriendRequest(String docId) async {
    try {
      // Reject the friend request
      await FirebaseFirestore.instance.collection('friendRequests').doc(docId).delete();

      // Show rejection message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request rejected')),
      );

      // Remove from the list in the UI
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
                  onPressed: () => acceptFriendRequest(request['id'], request['from']),
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
