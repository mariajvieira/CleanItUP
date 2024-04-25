import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
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
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/Avatar.png'),
                        radius: 55.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Name Surname',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                          fontFamily: 'Roboto-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'up*********',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.amber,
                          fontFamily: 'Roboto-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15.0),
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
        type: BottomNavigationBarType.fixed, // Fixed type of BottomNavigationBar
        backgroundColor: Colors.teal, // Background color
        selectedItemColor: Colors.white, // Color of the selected item
        unselectedItemColor: Colors.white70, // Color of the unselected items
        currentIndex: _selectedIndex, // Current index of the BottomNavigationBar
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.public), // trocar
            label: 'Global',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // trocar
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_checked), // Trocar
            label: 'Near me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), // Trocar
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), // Trocar
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticSection() {
    // Texto dos amigos, recycling bins, ...
    var numberStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    var labelStyle = TextStyle(
      color: Colors.white70,
      fontSize: 12,
    );

    Widget _buildStatistic(String number, String label, {bool isLarge = false}) {
      double width = isLarge ? 120.0 : 80.0; // Larger width for the 'RECYCLING BINS' box

      return Container(
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
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
        _buildStatistic('23', 'FRIENDS'),
        _buildStatistic('54', 'ECOPOINTS'),
        _buildStatistic('2', 'LEVEL'),
        _buildStatistic('17', 'RECYCLING BINS', isLarge: true),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Achievements',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 60.0, // altura dos icones
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: achievementIcons.length,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple,
                ),
                child: Image.asset(achievementIcons[index]), // Loads achievement icon
              );
            },
          ),
        ),
        Divider(color: Colors.teal, height: 20, thickness: 2), // Divider line
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Text(
            'Posts',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 200,
          child: GridView.builder(
            //physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

