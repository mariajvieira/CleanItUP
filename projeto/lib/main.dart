import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MaterialApp(
  home: MyHomePage(title: 'Flutter Demo Home Page'),
));


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


import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: InitialPage(),
));

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});


  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/asset1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Column(

          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  SizedBox(height: 200.0,),
                  Text('REUSE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Bold',
                    ),
                  ),
                  Text('REDUCE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Bold',
                    ),
                  ),
                  Text('RECYCLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Bold',
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text(' CleanItUP',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Bold',
                    ),)
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        label: const Text('Start',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.green,
          ),),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        },
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/LoginBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  const SizedBox(height: 220.0,),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text('CleanIt',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            letterSpacing: 2.0,
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto-Bold',
                          ),
                        ),
                        Text('UP',
                          style: TextStyle(
                            color: Colors.green,
                            letterSpacing: 2.0,
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto-Bold',
                          ),
                        )
                      ]
                  ),
                  const SizedBox(height: 10.0,),
                  const Text('Login with up email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Bold',
                    ),),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'up*********@up.pt',

                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'password',

                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text('By clicking continue, you agree to our ',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                      Text('Terms of Service ',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto-Regular',
                        ),)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('and',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontFamily: 'Roboto-Regular',
                        ),),
                      Text(' Privacy Policy',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto-Regular',
                        ),)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserProfile()),
          );
        },
        backgroundColor: Colors.white,
        child: const Text('Start',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.green,
          ),),

      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Center(
        child:Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 60.0,),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/Avatar.png'),
                radius: 55.0,
              ),
              const SizedBox(height: 10.0,),
              const Text('Name Surname',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontFamily: 'Roboto-Bold',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Text('up*********',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.amber,
                  fontFamily: 'Roboto-Bold',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Set button color to green
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '23',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'friends',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Set button color to green
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '18',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'ecopoints',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],

              )

            ],
          ),
        ),
      ),
    );
  }
}
*/



