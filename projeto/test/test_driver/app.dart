import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:projeto/screens/home_screen.dart';
import '../../../projeto/lib/main.dart';


void main() {
  // Enable the flutter driver extension.
  enableFlutterDriverExtension();

  // Here you call the same runApp method that your main.dart does,
  // except now it's being watched by the flutter driver extension.
  runApp(MaterialApp(
    home: MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}
