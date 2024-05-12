import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projeto/JsonModels/users.dart';
import 'package:projeto/screens/userprofile_screen.dart';

class Geolocation extends StatefulWidget {
  final Users user;

  const Geolocation({super.key, required this.user});

  @override
  _GeolocationState createState() => _GeolocationState();
}

class _GeolocationState extends State<Geolocation> {
  Position? currentLocation;
  String currentAddress = "";
  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.denied;

  Future<Position> getCurrentLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Consider showing a message to the user or returning a default position
      print("Location services are disabled.");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next steps are needed
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocation'),
      ),body: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 140),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/Mockup3esof.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              currentLocation = await getCurrentLocation();
              print("Current location is: $currentLocation");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile(user: widget.user)),
              );
            } catch (e) {
              print("Failed to get location: $e");
            }
          },
            child: const Text('Get Current Location'),
          ),
        ),
      ),
    );
  }
}