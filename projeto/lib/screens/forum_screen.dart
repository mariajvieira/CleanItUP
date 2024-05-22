import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_post_screen.dart';
import 'search_users_screen.dart';
import 'map_screen.dart';
import 'calendar_screen.dart';
import 'userprofile_screen.dart';
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

        List<Map<String, dynamic>> fetchedPosts = postsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

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
                      Icon(Icons.thumb_up, color: Colors.grey[600]),
                      SizedBox(width: 8.0),
                      Text('${post['likes'].length} Likes'),
                      SizedBox(width: 24.0),
                      Icon(Icons.comment, color: Colors.grey[600]),
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
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ForumScreen(user: widget.user)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MapScreen(user: widget.user)));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CalendarScreen(user: widget.user)));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => UserProfile(user: widget.user)));
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
