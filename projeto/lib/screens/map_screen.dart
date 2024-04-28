import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';




class MapScreen extends StatefulWidget{
  const MapScreen({super.key});

  @override
  State<MapScreen> createState()=> _MapState();
}

class _MapState extends State<MapScreen>{

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

    /*currentLocation= getCurrentLocation() as Position?; //NÃO FUNCIONA
    double? lat= currentLocation?.latitude;
    double? lng= currentLocation?.longitude;*/

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(41.178444, -8.596222),
        //initialCenter: LatLng(lat!, lng!), NÃO FUNCIONA
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://api.mapbox.com/styles/v1/duartemarques/clvfvlk3g017f01qu16r635mk/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZHVhcnRlbWFycXVlcyIsImEiOiJjbHZmdmZlZm8wZDV3MmlxbW5jdHV1OW05In0.xh3JCt1AYw53bHAb46Loeg',
          userAgentPackageName: 'com.example.app',
        ),
      ],
    );
  }
}