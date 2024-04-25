import 'package:flutter/material.dart';



class SecondScreen extends StatelessWidget {
  final VoidCallback _navigateToThirdScreen;

  const SecondScreen(this._navigateToThirdScreen, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/Mockup3esof.png"),
              fit: BoxFit.cover,
            ),
          )
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            /*bottom: 40,
            right: 20,
            left: 50,*/
            child: FloatingActionButton(
              onPressed: _navigateToThirdScreen,
              tooltip: 'Increment',
              backgroundColor: Colors.white,
              elevation: 6,
              child: const Text('Sim'),
            ),
          ),
        ],
      ),
    );
  }
}


/*
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Screen"),
      ),
      body: const Center(
        child: Text("Welcome to the second screen!"),
      ),
    );
  }
}
*/