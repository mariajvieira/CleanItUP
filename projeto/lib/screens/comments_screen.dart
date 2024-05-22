import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../JsonModels/users.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  final Users user;

  const CommentsScreen({Key? key, required this.postId, required this.user}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Map<String, dynamic>> comments = [];
  Map<String, String> userNames = {};
  String newComment = '';

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      var postSnapshot = await FirebaseFirestore.instance.collection('Posts').doc(widget.postId).get();
      if (postSnapshot.exists) {
        var postData = postSnapshot.data() as Map<String, dynamic>;
        List<dynamic> commentsData = postData['comments'] ?? [];

        List<Map<String, dynamic>> fetchedComments = [];
        for (var comment in commentsData) {
          String userId = comment['userId'];
          if (!userNames.containsKey(userId)) {
            var userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
            if (userSnapshot.exists) {
              var userData = userSnapshot.data() as Map<String, dynamic>;
              userNames[userId] = '${userData['firstName']} ${userData['lastName']}';
            }
          }
          fetchedComments.add(comment);
        }

        setState(() {
          comments = fetchedComments;
        });
      }
    } catch (e) {
      print('Error loading comments: $e');
    }
  }

  Future<void> _addComment(String comment) async {
    try {
      var postRef = FirebaseFirestore.instance.collection('Posts').doc(widget.postId);
      await postRef.update({
        'comments': FieldValue.arrayUnion([{'userId': widget.user.id, 'comment': comment}])
      });
      _loadComments();
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  void _showAddCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment'),
        content: TextField(
          onChanged: (value) {
            newComment = value;
          },
          decoration: InputDecoration(hintText: "Enter your comment"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              if (newComment.isNotEmpty) {
                _addComment(newComment);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: comments.isEmpty
          ? Center(child: Text('No comments yet'))
          : ListView.builder(
        itemCount: comments.length,
        itemBuilder: (BuildContext context, int index) {
          var comment = comments[index];
          var userName = userNames[comment['userId']] ?? 'Unknown User';
          return ListTile(
            title: Text(userName),
            subtitle: Text(comment['comment']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCommentDialog,
        child: Icon(Icons.add_comment),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
