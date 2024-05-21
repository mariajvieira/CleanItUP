import 'package:flutter/material.dart';
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

  // Sample list of posts
  final List<Map<String, dynamic>> posts = [
    {
      "username": "John Smith",
      "image": "lib/assets/volunteer.png",
      "likes": 15,
      "comments": 6,
      "content": "Had an amazing day, cleaning the beach with my friends.",
    },
    {
      "username": "Anne Silva",
      "image": "lib/assets/garbage.png",
      "likes": 24,
      "comments": 17,
      "content": "Working on my newest recycling project, with my kids. Results soon",
    },
    {
      "username": "Laura Santos",
      "image": "lib/assets/clothing.png",
      "likes": 15,
      "comments": 6,
      "content": "Come to the flea market near FEUP. A great opportunity for recycling while making some extra money.",
    },
  ];

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
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(posts[index]['image']),
                  ),
                  title: Text(posts[index]['username']),
                  subtitle: Text(posts[index]['content']),
                ),
                Image.asset(posts[index]['image']),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.thumb_up, color: Colors.grey[600]),
                      SizedBox(width: 8.0),
                      Text('${posts[index]['likes']} Likes'),
                      SizedBox(width: 24.0),
                      Icon(Icons.comment, color: Colors.grey[600]),
                      SizedBox(width: 8.0),
                      Text('${posts[index]['comments']} Comments'),
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
