import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../JsonModels/users.dart';
import '../JsonModels/friend.dart';
import 'account_settings_screen.dart';
import 'forum_screen.dart';
import 'map_screen.dart';
import 'calendar_screen.dart';
import 'friend_requests_screen.dart';
import 'friend_list_screen.dart';
import 'near_me_screen.dart';
import 'quiz_screen.dart';
import 'post_details_screen.dart';

class UserProfile extends StatefulWidget {
  final Users user;

  const UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _selectedIndex = 4;
  int numberOfFriends = 0;
  int numberOfPosts = 0;
  int greenScore = 0;
  String profileImageUrl = '';
  List<Map<String, dynamic>> userPosts = [];
  List<Friend> friendsList = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadFriends();
    _listenToPostChanges();
    _listenToScoreChanges();
  }

  void _loadUserData() async {
    try {
      final DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(widget.user.id).get();
      setState(() {
        numberOfPosts = userData['postCount'] ?? 0;
        greenScore = userData['points'] ?? 0;
        profileImageUrl = userData['profileImageUrl'] ?? '';
      });
      print('User Data Loaded: $userData');
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _loadFriends() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('friends').where('userId', isEqualTo: widget.user.id).get();
      setState(() {
        friendsList = snapshot.docs.map((doc) => Friend.fromFirestore(doc)).toList();
        numberOfFriends = friendsList.length;
      });
      print('Friends Loaded: $friendsList');
    } catch (e) {
      print('Error loading friends: $e');
    }
  }

  void _listenToPostChanges() {
    FirebaseFirestore.instance.collection('Posts')
        .where('userId', isEqualTo: widget.user.id)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        numberOfPosts = snapshot.docs.length;
        userPosts = snapshot.docs.map((doc) => doc.data()).toList();
      });
      print('Post Changes Detected: $userPosts');
    });
  }

  void _listenToScoreChanges() {
    FirebaseFirestore.instance.collection('users').doc(widget.user.id).snapshots().listen((snapshot) {
      setState(() {
        greenScore = snapshot['points'] ?? 0;
      });
      print('Score Changes Detected: $greenScore');
    });
  }

  Widget _buildPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            'Posts',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        if (userPosts.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'No posts yet',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                var post = userPosts[index];
                print('Displaying Post: $post');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailsScreen(
                          post: post,
                          userName: '${widget.user.firstName} ${widget.user.lastName}',
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    post['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        const Divider(color: Colors.teal, thickness: 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsScreen(user: widget.user)));
                },
              ),
              IconButton(
                icon: Icon(Icons.group_add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendRequestsScreen(onFriendRequestAccepted: _loadFriends),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('lib/assets/LoginBackground.png', fit: BoxFit.cover),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : AssetImage('assets/Avatar.png') as ImageProvider,
                        radius: 55.0,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        '${widget.user.firstName} ${widget.user.lastName}',
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                          fontFamily: 'Roboto-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15.0),
                      _buildStatisticSection(),
                      _buildPostsSection(),
                      _buildQuizButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildStatisticSection() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        _buildStatisticItem('$numberOfFriends', 'FRIENDS', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FriendListScreen(user: widget.user)));
        }),
        _buildStatisticItem('$numberOfPosts', 'POSTS', () {}),
        _buildStatisticItem('$greenScore', 'GREEN SCORE', () {}),
      ],
    );
  }

  Widget _buildStatisticItem(String number, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(number, style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizScreen(user: widget.user)),
          );
        },
        child: Text('Take a Quiz', style: TextStyle(fontSize: 18.0)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.teal,
        ),
      ),
    );
  }
}
