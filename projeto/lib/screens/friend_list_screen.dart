import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../JsonModels/friend.dart';
import '../JsonModels/users.dart';

class FriendListScreen extends StatefulWidget {
  final Users user;

  const FriendListScreen({Key? key, required this.user}) : super(key: key);

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  List<Friend> friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('friends')
          .where('userId', isEqualTo: widget.user.id)
          .get();

      setState(() {
        friends = snapshot.docs.map((doc) => Friend.fromFirestore(doc)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading friends: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : friends.isEmpty
          ? Center(
        child: Text(
          'No friends yet',
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(friends[index].name),
            subtitle: Text(friends[index].email),
          );
        },
      ),
    );
  }
}
