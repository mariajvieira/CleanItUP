import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:projeto/screens/home_screen.dart';


void main() {

  enableFlutterDriverExtension();

  runApp(const MaterialApp(
    home: MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}
