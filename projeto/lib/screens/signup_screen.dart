import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirm_password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  String errorMessage = "Please enter all fields correctly";
  bool isVisible = false;
  bool isVisible_ = false;
  bool isSignUpFailed = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  void setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
      isSignUpFailed = true;
    });
  }

  Future<void> createUserProfile(String userId) async {
    return _firestore.collection('users').doc(userId).set({
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'email': username.text.trim(),
    });
  }

  void signup() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (username.text.isEmpty || !username.text.contains('@up.pt')) {
      setErrorMessage("Invalid email. Use your UP email");
      return;
    }

    if (password.text.isEmpty || confirm_password.text.isEmpty ||
        password.text != confirm_password.text) {
      setErrorMessage("Passwords do not match");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: username.text,
        password: password.text,
      );
      if (userCredential.user != null) {
        await createUserProfile(userCredential.user!.uid);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        setErrorMessage(e.message ?? "An error occurred. Please try again.");
      } else {
        setErrorMessage("An unknown error occurred.");
      }
    }
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
                      const SizedBox(height: 20.0),
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
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Text('Sign up with your UP email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto-Bold',
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: firstName,
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: lastName,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@up.pt')) {
                            return 'Please enter a valid UP email';
                          }
                          return null;
                        },
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
                            },
                            icon: Icon(
                                isVisible ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: confirm_password,
                        obscureText: !isVisible_,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Confirm Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible_ = !isVisible_;
                              });
                            },
                            icon: Icon(
                                isVisible_ ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Roboto-Regular',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto-Regular',
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isSignUpFailed)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      FloatingActionButton(
                        onPressed: signup,
                        tooltip: 'Sign Up',
                        backgroundColor: Colors.white,
                        elevation: 6,
                        child: const Text('SIGN UP'),
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