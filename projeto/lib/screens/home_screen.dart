import 'package:flutter/material.dart';
import 'login_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Mockup1esof.png"),
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
                    MaterialPageRoute(builder: (context) => const Login()) );
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
