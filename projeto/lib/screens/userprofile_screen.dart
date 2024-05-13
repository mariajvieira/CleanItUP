import 'package:flutter/material.dart';
import 'package:projeto/JsonModels/users.dart';
import '../SQLite/sqlite.dart';
import 'forum_screen.dart';
import 'map_screen.dart';
import 'package:projeto/screens/calendar_screen.dart';


class UserProfile extends StatefulWidget {
  final Users user;

  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}



class _UserProfileState extends State<UserProfile> {
  int _selectedIndex = 0;
  int numberOfFriends = 0;
  int numberOfPosts = 0;
  List<Map<String, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final db = UsersDatabaseHelper();
    if (widget.user.userId != null) {
      final friendsCount = await db.countUserFriends(widget.user.userId!);
      final posts = await db.getUserPosts(widget.user.userId!);
      setState(() {
        numberOfFriends = friendsCount;
        numberOfPosts = posts.length;
        userPosts = posts;
      });
    }
  }


  Widget _buildPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,  // Ensures alignment starts from the start horizontally
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
                return Image.asset(
                  post['image_path'],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        const Divider(color: Colors.teal, thickness: 2),  // Divider after the section
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
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/Avatar.png'),
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
                      const Text(
                        'up*********',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.amber,
                          fontFamily: 'Roboto-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15.0),
                      _buildStatisticSection(),
                      _buildAchievementsSection(),
                      _buildPostsSection(),
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ForumScreen()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MapScreen()));
        break;
      case 3: // Assuming 'Calendar' is at index 3
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CalendarScreen(user: widget.user,)));
        break;
    }
  }


  Widget _buildStatisticSection() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        _buildStatisticItem('$numberOfFriends', 'FRIENDS'),
        _buildStatisticItem('$numberOfPosts', 'POSTS'),
        // Add more items as needed
      ],
    );
  }

  Widget _buildStatisticItem(String number, String label) {
    return Container(
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
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
      children: [
        const Divider(color: Colors.teal, thickness: 2),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          // Consistent padding
          child: Text(
            'Achievements',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(color: Colors.teal, thickness: 2),  // Divider after the section
      ],
    );
  }
}