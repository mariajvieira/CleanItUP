import 'package:flutter/material.dart';

class FriendRequestsScreen extends StatefulWidget {
  @override
  _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  // Placeholder list of friend requests
  List<Map<String, dynamic>> friendRequests = [
    {'name': 'John Doe', 'accepted': false},
    {'name': 'Jane Smith', 'accepted': false},
  ];

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
                  onPressed: () {
                    // Logic to accept request
                    setState(() {
                      friendRequests[index]['accepted'] = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    // Logic to reject request
                    setState(() {
                      friendRequests.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
