import 'package:flutter/material.dart';
import '../JsonModels/users.dart';
import '../main.dart';
import 'geolocation_screen.dart';
import '../SQLite/sqlite.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void _navigateToSecondScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondScreen(_GeolocationState)),
    );
  }

  void _GeolocationState() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Geolocation()),
    );
  }


  final username = TextEditingController();
  final password = TextEditingController();
  bool isVisible=false;

  bool isLoginTrue = false;

  final db = UsersDatabaseHelper();
  final String defaultUsername = 'up12345678@up.pt';
  final String defaultPassword = 'teste';

  //Now we should call this function in login button
  void login() async {
      var response = await db.login(Users(userName: username.text, userPassword: password.text));
      if (response) {
        // Successful login
        // Navigate to the next screen or perform other actions
        isLoginTrue=false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SecondScreen(_GeolocationState)),
        );
      } else {
        // Invalid credentials
        // Display an error message or handle the login failure
        setState(() {
          isLoginTrue = true;
        });
      }
  }

  //We have to create global key for our form
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/LoginBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: formKey,
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
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "username is required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'up*********@up.pt',

                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password is required";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            }, icon: Icon(isVisible? Icons.visibility : Icons.visibility_off),
                          )
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
                    // Display error message if login fails
                    isLoginTrue
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Username or password is incorrect",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        )
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
                if (username.text == defaultUsername &&
                    password.text == defaultPassword) {
                  _navigateToSecondScreen();
                }
                /*
                if (formKey.currentState!.validate()) {
                  login();
                  }*/
              },
              tooltip: 'Increment',
              backgroundColor: Colors.white,
              elevation: 6,
              child: const Text('LOGIN'),
            ),
          )
        ],
      )

    );
  }
}
