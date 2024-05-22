import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  final String userName;

  const PostDetailsScreen({Key? key, required this.post, required this.userName}) : super(key: key);

  Future<String> _getUserName(String userId) async {
    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var userData = userDoc.data();
        return '${userData!['firstName']} ${userData['lastName']}';
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
    return 'Unknown User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              userName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              post['description'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Image.network(post['imageUrl']),
            SizedBox(height: 10),
            Text(
              '${post['likes'].length} Likes',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '${post['comments'].length} Comments',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: post['comments'].length,
                itemBuilder: (context, index) {
                  var comment = post['comments'][index];
                  return FutureBuilder<String>(
                    future: _getUserName(comment['userId']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: Text(comment['comment']),
                          subtitle: Text('Loading...'),
                        );
                      }
                      return ListTile(
                        title: Text(comment['comment']),
                        subtitle: Text(snapshot.data ?? 'Unknown User'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
