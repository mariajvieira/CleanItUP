import 'package:flutter/material.dart';
import '../JsonModels/users.dart';
import 'geolocation_screen.dart';  // Make sure this import is correct
import 'signup_screen.dart';
import '../SQLite/sqlite.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isVisible = false;
  bool isLoginFailed = false;
  String errorMessage = "Username or password is incorrect";  // Default error message

  final db = UsersDatabaseHelper();  // Assuming db methods are correctly implemented

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (username.text.isEmpty || password.text.isEmpty) {
      setState(() {
        errorMessage = "Username and password required";
        isLoginFailed = true;
      });
      return;
    }

    bool loggedIn = await db.login(username.text, password.text);
    if (loggedIn) {
      Users? user = await db.getUserByUsername(username.text);
      if (user != null) {
        _navigateToGeoLocationScreen(user);
      } else {
        setState(() {
          errorMessage = "Failed to retrieve user details";
          isLoginFailed = true;
        });
      }
    } else {
      setState(() {
        errorMessage = "Username or password is incorrect";
        isLoginFailed = true;
      });
    }
  }

  void _navigateToGeoLocationScreen(Users user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Geolocation(user: user)), // Make sure Geolocation accepts a Users object
    );
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/LoginBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget> [
                      const SizedBox(height: 20.0,),
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
                      const Text('Login with your UP email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto-Bold',
                        ),),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: username,
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
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Password',
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
                        children: [
                          const Text("Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Roboto-Regular',
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              child: const Text("SIGN UP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto-Regular',
                                ),))
                        ],
                      ),
                      if (isLoginFailed)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: const Text('LOGIN'),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            login();
          }
        },
        tooltip: 'Login',
        backgroundColor: Colors.white,
        elevation: 6,
        child: const Text('LOGIN'),
      ),
    );
  }
}
