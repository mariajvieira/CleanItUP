import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_post_screen.dart';
import 'near_me_screen.dart';
import 'search_users_screen.dart';
import 'map_screen.dart';
import 'calendar_screen.dart';
import 'userprofile_screen.dart';
import 'comments_screen.dart';
import '../JsonModels/users.dart';

class ForumScreen extends StatefulWidget {
  final Users user;
  const ForumScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> posts = [];
  Map<String, String> userNames = {};

  @override
  void initState() {
    super.initState();
    _loadFriendsPosts();
  }

  Future<void> _loadFriendsPosts() async {
    try {
      var friendsSnapshot = await FirebaseFirestore.instance
          .collection('friends')
          .where('userId', isEqualTo: widget.user.id)
          .get();

      List<String> friendsIds = friendsSnapshot.docs
          .map((doc) => doc['friendId'] as String)
          .toList();

      if (friendsIds.isNotEmpty) {
        var postsSnapshot = await FirebaseFirestore.instance
            .collection('Posts')
            .where('userId', whereIn: friendsIds)
            .orderBy('date', descending: true)
            .get();

        List<Map<String, dynamic>> fetchedPosts = postsSnapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id; // Adiciona o ID do documento ao post
          return data;
        }).toList();

        for (var post in fetchedPosts) {
          String userId = post['userId'];
          if (!userNames.containsKey(userId)) {
            var userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
            if (userSnapshot.exists) {
              var userData = userSnapshot.data() as Map<String, dynamic>;
              userNames[userId] = '${userData['firstName']} ${userData['lastName']}';
            }
          }
        }

        setState(() {
          posts = fetchedPosts;
        });
      }
    } catch (e) {
      print('Error loading friends\' posts: $e');
    }
  }

  Future<void> _toggleLike(String postId, bool isLiked) async {
    try {
      var postRef = FirebaseFirestore.instance.collection('Posts').doc(postId);
      if (isLiked) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([widget.user.id])
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([widget.user.id])
        });
      }
      _loadFriendsPosts(); // Atualiza a lista de posts
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> _addComment(String postId, String comment) async {
    try {
      var postRef = FirebaseFirestore.instance.collection('Posts').doc(postId);
      await postRef.update({
        'comments': FieldValue.arrayUnion([{'userId': widget.user.id, 'comment': comment}])
      });
      _loadFriendsPosts(); // Atualiza a lista de posts
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  void _showAddCommentDialog(String postId) {
    String comment = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment'),
        content: TextField(
          onChanged: (value) {
            comment = value;
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
              _addComment(postId, comment);
              Navigator.of(context).pop();
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
        title: Text('Forum', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchUsersScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()),
            ),
          ),
        ],
      ),
      body: posts.isEmpty
          ? Center(child: Text('No posts yet'))
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          var post = posts[index];
          var userName = userNames[post['userId']] ?? 'Unknown User';
          var isLiked = post['likes'].contains(widget.user.id);

          return Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(post['imageUrl']),
                  ),
                  title: Text(userName),
                  subtitle: Text(post['description']),
                ),
                Image.network(post['imageUrl']),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined, color: Colors.grey[600]),
                        onPressed: () {
                          _toggleLike(post['id'], isLiked);
                        },
                      ),
                      SizedBox(width: 8.0),
                      Text('${post['likes'].length} Likes'),
                      SizedBox(width: 24.0),
                      IconButton(
                        icon: Icon(Icons.comment, color: Colors.grey[600]),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(postId: post['id'], user: widget.user),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 8.0),
                      Text('${post['comments'].length} Comments'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Global',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_checked),
            label: 'Near me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumScreen(user: widget.user)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen(user: widget.user)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NearMeScreen(user: widget.user)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen(user: widget.user)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfile(user: widget.user)),
        );
        break;
    }
  }

  void _navigateToAddUserScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SearchUsersScreen()));
  }

  void _navigateToAddPostScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddPostScreen()));
  }
}
