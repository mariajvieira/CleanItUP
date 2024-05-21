import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projeto/screens/userprofile_screen.dart';
import '../JsonModels/users.dart';
import 'calendar_screen.dart';
import 'forum_screen.dart';



class MapScreen extends StatefulWidget{
  final Users user;

  const MapScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MapScreen> createState()=> _MapState();
}

class _MapState extends State<MapScreen>{
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    /*
    Position? currentLocation;
    late bool servicePermission = false;
    late LocationPermission permission;
    String currentAdress = "";
    Future<Position> getCurrentLocation() async{
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if(!servicePermission){
        print("Service Disabled");
      }
      permission = await Geolocator.checkPermission();
      if(permission==LocationPermission.denied){
        permission = await Geolocator.requestPermission();
      }
      return await Geolocator.getCurrentPosition();
    }
    */
    /*currentLocation= getCurrentLocation() as Position?; //NÃO FUNCIONA
    double? lat= currentLocation?.latitude;
    double? lng= currentLocation?.longitude;*/

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
      body: map(),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ForumScreen(user: widget.user)
        ));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  MapScreen(user: widget.user)));
        break;
      case 2:
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen(user: widget.user,)));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(user: widget.user)));
        break;
    }
  }

}

Future<void> getBins(List<Marker> m) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('recyclingBins').get();

    querySnapshot.docs.forEach((doc) {
      double latitude = doc['latitude'];
      double longitude = doc['longitude'];

      m.add(
        Marker(
          point: LatLng(latitude, longitude),
          child: Image.asset("lib/assets/bin.png"),
        ),
      );
    });
  } catch (e) {
    print("Error fetching recycling bins: $e");
  }
}

Widget map() {
  List<Marker> m = [];
  getBins(m);

  return FlutterMap(
    options: const MapOptions(
      initialCenter: LatLng(41.178444, -8.596222),
      initialZoom: 19,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://api.mapbox.com/styles/v1/duartemarques/clw49mqbq02jn01qve0cd8ih1/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZHVhcnRlbWFycXVlcyIsImEiOiJjbHZmdmZlZm8wZDV3MmlxbW5jdHV1OW05In0.xh3JCt1AYw53bHAb46Loeg',
        userAgentPackageName: 'com.example.app',
      ),
      MarkerLayer(
        markers: m,
      ),
    ],
  );
}
