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

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('friends')
        .where('user1Id', isEqualTo: widget.user.id)
        .orderBy('name') // Assuming 'name' field exists and is correct
        .get();

    setState(() {
      friends = snapshot.docs.map((doc) => Friend.fromFirestore(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
      ),
      body: ListView.builder(
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
