import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../JsonModels/users.dart'; // Make sure this path is correct
import 'geolocation_screen.dart';
import 'signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisible = false;
  bool isLoginFailed = false;
  String errorMessage = "Username or password is incorrect";

  Future<Users?> fetchAdditionalUserInfo(String uid) async {
    try {
      var userDocument = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDocument.exists) {
        return Users.fromFirestore(userDocument);
      } else {
        print("User data not found in Firestore for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
      return null;
    }
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text.trim(), // Trim to remove any accidental whitespace
          password: passwordController.text,
        );
        final user = userCredential.user;
        if (user != null) {
          final Users? additionalUserInfo = await fetchAdditionalUserInfo(user.uid);
          if (additionalUserInfo != null) {
            _navigateToGeoLocationScreen(additionalUserInfo);
          } else {
            setState(() {
              errorMessage = "User data not found. Please complete your profile.";
              isLoginFailed = true;
            });
          }
        }
      } catch (e, stackTrace) { // Catching stack trace for more detailed debug information
        print("Failed to log in: $e");
        print("Stack trace: $stackTrace"); // This will provide a detailed stack trace
        if (e is FirebaseAuthException) {
          print('Firebase Auth error: ${e.code}');
          errorMessage = e.message ?? "An error occurred. Please try again.";
        } else {
          errorMessage = "An unknown error occurred. Details: ${e.toString()}";
        }
        setState(() {
          isLoginFailed = true;
        });
      }
    }
  }

  void _navigateToGeoLocationScreen(Users user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Geolocation(user: user)), // Ensure Geolocation accepts a Users object
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
                        controller: usernameController,
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
                        controller: passwordController,
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
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
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
    );
  }
}