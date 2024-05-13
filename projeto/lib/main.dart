import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


void main() => runApp(const MaterialApp(
  home: MyHomePage(title: 'Flutter Demo Home Page'),
));


//com firebase
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugin services are initialized
  await Firebase.initializeApp();             // Initialize Firebase

  runApp(MyApp());                           // Run the app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

 */
