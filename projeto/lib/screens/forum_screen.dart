import 'package:flutter/material.dart';
import 'add_post_screen.dart';
import 'search_users_screen.dart'; // Make sure to import your AddUserScreen

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<Map<String, dynamic>> posts = [
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
      "content": "Come to the flea market near feup. A great opportunity for recycling while making some extra money.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CleanItUP', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _navigateToAddUserScreen(context),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToAddPostScreen(context),
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
                    backgroundImage: AssetImage('assets/avatar.png'),
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
    );
  }

  void _navigateToAddPostScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPostScreen()),
    );
  }

  void _navigateToAddUserScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchUsersScreen()),
    );
  }
}
