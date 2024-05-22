import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto/screens/userprofile_screen.dart';
import '../JsonModels/users.dart';
import 'calendar_screen.dart';
import 'forum_screen.dart';
import 'map_screen.dart';

class NearMeScreen extends StatefulWidget {
  final Users user;
  const NearMeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _NearMeScreenState createState() => _NearMeScreenState();
}

class _NearMeScreenState extends State<NearMeScreen> {
  int _selectedIndex = 2;
  Position? _currentPosition;
  Timer? _timer;
  List<DocumentSnapshot> _nearbyBins = [];
  final double _maxDistance = 10; // Define the max distance in meters

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    _fetchNearbyBins();
  }

  Future<void> _fetchNearbyBins() async {
    if (_currentPosition == null) return;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('RecyclingBins').get();

      List<DocumentSnapshot> nearbyBins = querySnapshot.docs.where((doc) {
        double latitude = doc['latitude'];
        double longitude = doc['longitude'];
        double distance = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          latitude,
          longitude,
        );
        return distance <= _maxDistance;
      }).toList();

      setState(() {
        _nearbyBins = nearbyBins;
      });
    } catch (e) {
      print("Error fetching recycling bins: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Near Me'),
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
      body: Center(
        child: _currentPosition == null
            ? CircularProgressIndicator()
            : _nearbyBins.isEmpty
            ? Text('No nearby bins found.')
            : ListView.builder(
          itemCount: _nearbyBins.length,
          itemBuilder: (context, index) {
            var bin = _nearbyBins[index];
            return ListTile(
              leading: Icon(Icons.delete),
              title: Text('Recycling Bin at (${bin['latitude']}, ${bin['longitude']})'),
              subtitle: Text('Type: ${bin['type']}'),
            );
          },
        ),
      ),
    );
  }
}
