import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../JsonModels/users.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({Key? key}) : super(key: key);

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Users> _searchResults = [];
  bool _isSearching = false;
  List<String> _friendsIds = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    var friendsSnapshot = await FirebaseFirestore.instance
        .collection('friends')
        .where('userId', isEqualTo: currentUser)
        .get();

    setState(() {
      _friendsIds = friendsSnapshot.docs.map((doc) => doc['friendId'] as String).toList();
    });
  }

  void sendFriendRequest(Users user) async {
    var currentUser = FirebaseAuth.instance.currentUser!;
    try {
      var currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      var currentUserData = currentUserDoc.data();
      var currentUserName = (currentUserData?['firstName'] ?? 'Unknown') + ' ' + (currentUserData?['lastName'] ?? '');

      await FirebaseFirestore.instance.collection('friendRequests').add({
        'senderId': currentUser.uid,
        'receiverId': user.id,
        'senderName': currentUserName,
        'status': 'pending'
      });
      setState(() {
        user.isRequestSent = true;
      });
    } catch (e) {
      print("Error sending request: $e");
    }
  }

  void removeFriendRequest(Users user) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('friendRequests')
          .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('receiverId', isEqualTo: user.id)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      setState(() {
        user.isRequestSent = false;
      });
    } catch (e) {
      print("Error removing request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _searchUsers(_searchController.text.trim()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchResults = []);
                  },
                ),
              ),
              onChanged: (value) => _searchUsers(value),
            ),
          ),
          Expanded(
            child: _isSearching
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var user = _searchResults[index];
                if (user.id == FirebaseAuth.instance.currentUser!.uid) {
                  return Container();
                }
                bool isFriend = _friendsIds.contains(user.id);
                return ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  trailing: isFriend
                      ? Text(
                    'Friends',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  )
                      : IconButton(
                    icon: Icon(
                        user.isRequestSent ? Icons.undo : Icons.person_add),
                    onPressed: () {
                      if (user.isRequestSent) {
                        removeFriendRequest(user);
                      } else {
                        sendFriendRequest(user);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      var currentUser = FirebaseAuth.instance.currentUser!.uid;
      var usersCollection = FirebaseFirestore.instance.collection('users');
      var emailQuery = usersCollection
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: query + '\uf8ff');

      var emailResults = await emailQuery.get();

      var requestsCollection = FirebaseFirestore.instance.collection('friendRequests');
      var requestsQuery = requestsCollection
          .where('senderId', isEqualTo: currentUser)
          .where('status', isEqualTo: 'pending');

      var sentRequests = await requestsQuery.get();
      var sentRequestsIds = sentRequests.docs.map((doc) => doc['receiverId']).toList();

      setState(() {
        _searchResults = emailResults.docs.map((doc) {
          var user = Users.fromFirestore(doc);
          user.isRequestSent = sentRequestsIds.contains(user.id);
          return user;
        }).toList();
        _isSearching = false;
      });
    } catch (e) {
      print("Error searching users by email: $e");
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }
}
