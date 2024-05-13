import 'package:flutter/material.dart';
import 'package:projeto/JsonModels/users.dart';
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
                      // Add posts grid here
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForumScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(user: widget.user,)));
        break;
      case 3:  // Assuming 'Calendar' is at index 3
        Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen(user: widget.user,)));
        break;
    }
  }


  Widget _buildStatisticSection() {
    // Texto dos amigos, recycling bins, ...
    var numberStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    var labelStyle = const TextStyle(
      color: Colors.white70,
      fontSize: 12,
    );

    Widget buildStatistic(String number, String label, {bool isLarge = false}) {
      double width = isLarge ? 120.0 : 80.0; // Larger width for the 'RECYCLING BINS' box

      return Container(
        width: width,
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
            Text(number, style: numberStyle, textAlign: TextAlign.center),
            FittedBox(
              fit: BoxFit.fitWidth, // scales the text down if not fit
              child: Text(label, style: labelStyle, textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 8.0, // horizontal space
      runSpacing: 8.0, // vertical space
      children: <Widget>[
        buildStatistic('23', 'FRIENDS'),
        buildStatistic('54', 'ECOPOINTS'),
        buildStatistic('2', 'LEVEL'),
        buildStatistic('17', 'RECYCLING BINS', isLarge: true),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    // part of achievements
    List<String> achievementIcons = [
      //acrescentar
      'assets/icon.png',
      'assets/icon_.png',
      'assets/icon_.png',
      'assets/icon_.png',
      'assets/icon_.png',
      'assets/icon_.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Achievements',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 60.0, // altura dos icones
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: achievementIcons.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple,
                ),
                child: Image.asset(achievementIcons[index]), // Loads achievement icon
              );
            },
          ),
        ),
        const Divider(color: Colors.teal, height: 20, thickness: 2), // Divider line
      ],
    );
  }


  Widget _buildPostsSection() {
    // list of image paths for posts
    //to do
    List<String> postImages = [
      'assets/post1.jpg',
      'assets/post2.jpg',
      'assets/post3.jpg',
      'assets/post4.jpg',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Text(
            'Posts',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: GridView.builder(
            //physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10, // Space between images horizontally
              mainAxisSpacing: 10, // Space between images vertically
              childAspectRatio: 1, //  ratio
            ),
            itemCount: postImages.length,
            itemBuilder: (context, index) {
              return Image.asset(
                postImages[index],
                fit: BoxFit.cover, // fills the space, cropping if necessary
              );
            },
          ),
        ),
      ],
    );
  }
}

