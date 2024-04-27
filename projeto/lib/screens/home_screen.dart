import 'package:flutter/material.dart';
import 'login_screen.dart';  // Ensure you have imported the Login screen correctly

// MyHomePage StatefulWidget Declaration
class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// State Class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Mockup1esof.png"),  // Adjust path if necessary
            fit: BoxFit.cover,
          ),
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            bottom: 40,
            right: 20,
            left: 50,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              backgroundColor: Colors.white,
              elevation: 6,
              child: const Text('Start'),
            ),
          ),
        ],
      ),
    );
  }
}
