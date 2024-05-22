import 'dart:async';
import 'dart:math';
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
_timer = Timer.periodic(Duration(seconds: 2), (timer) {
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

void _showBinDetails(DocumentSnapshot bin) {
  String t="";
  if( bin['type']=='G'){
    t = "Glass";
  }
  else if(bin['type']=='B'){
    t = "Batteries";
  }
  else if(bin['type']=='P') {
    t = "Plastic";
  }
  else if(bin['type']=='PC') {
    t = "Paper";
  }
  else if(bin['type']=='C') {
    t = "Clothes";
  }
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text('Recycling Bin Details'),
content: Text('Type: ${t}\nLocation: ${bin['description']}'),
actions: <Widget>[
TextButton(
child: Text('Close'),
onPressed: () {
Navigator.of(context).pop();
},
),
],
);
},
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
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
body: Container(
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage('lib/assets/near_me.png'),
fit: BoxFit.cover,
),
),
child: Center(
child: _currentPosition == null
? CircularProgressIndicator()
    : _nearbyBins.isEmpty
? Text('No nearby bins found.')
    : Stack(
children: _nearbyBins.map((bin) {
// Calculando a posição para os ícones
double angle = (_nearbyBins.indexOf(bin) / _nearbyBins.length) * 2 * 3.14159;
double radius = 130.0; // Raio do círculo
double x = radius * cos(angle);
double y = radius * sin(angle);

return Positioned(
left: MediaQuery.of(context).size.width / 2 + x,
top: MediaQuery.of(context).size.height / 2 + y,
child: GestureDetector(
onTap: () => _showBinDetails(bin),
child: Image.asset(
  'lib/assets/${bin['type']}.png',
width: 50,
height: 50,
),
),
);
}).toList(),
),
),
),
);
}
}
