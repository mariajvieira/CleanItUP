import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../JsonModels/users.dart';
import 'signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userprofile_screen.dart';

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

  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.denied;
  Position? currentLocation;

  final formKey = GlobalKey<FormState>();

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

  Future<Position> getCurrentLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text,
        );
        final user = userCredential.user;
        if (user != null) {
          final Users? additionalUserInfo = await fetchAdditionalUserInfo(user.uid);
          if (additionalUserInfo != null) {
            try {
              currentLocation = await getCurrentLocation();
              print("Current location is: $currentLocation");
              _navigateToUserProfileScreen(additionalUserInfo);
            } catch (e) {
              print("Failed to get location: $e");
              setState(() {
                errorMessage = "Failed to get location. Please enable location services.";
                isLoginFailed = true;
              });
            }
          } else {
            setState(() {
              errorMessage = "User data not found. Please complete your profile.";
              isLoginFailed = true;
            });
          }
        }
      } catch (e, stackTrace) {
        print("Failed to log in: $e");
        print("Stack trace: $stackTrace");
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

  void _navigateToUserProfileScreen(Users user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProfile(user: user)),
    );
  }

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
                    children: <Widget>[
                      const SizedBox(height: 20.0,),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                              }, icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
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
