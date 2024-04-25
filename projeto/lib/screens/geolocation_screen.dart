import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projeto/screens/userprofile_screen.dart';

class Geolocation extends StatelessWidget {
  const Geolocation({super.key});
  @override
  Widget build(BuildContext context) {
    return _GeolocationState();
  }
}

class _GeolocationState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeolocationStateState();
}


class _GeolocationStateState extends State<_GeolocationState> {
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Geolocation'),
        ),
        body: Center(
            child: ElevatedButton(
              onPressed: ()async{
                currentLocation= await getCurrentLocation();
                print("$currentLocation");
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()) );
              }, child: const Text('Get Current Location'),
            )
        )
    );
  }
}  //VAI SER PAGINA DO MAPA

