import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../JsonModels/users.dart';
import 'login_screen.dart';
import '../SQLite/sqlite.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirm_password = TextEditingController();
  final firstName = TextEditingController();  // Controller for first name
  final lastName = TextEditingController();   // Controller for last name
  String errorMessage = "Username or password is incorrect";  // Default error message

  bool isVisible = false;
  bool isVisible_ = false;
  bool isSignUpFailed = false;
  final db = UsersDatabaseHelper();

  void signup() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check each field and set specific error messages
    if (firstName.text.isEmpty) {
      setErrorMessage("First name is required");
      return;
    }

    if (lastName.text.isEmpty) {
      setErrorMessage("Last name is required");
      return;
    }

    if (username.text.isEmpty) {
      setErrorMessage("Email is required");
      return;
    } else if (!username.text.endsWith('@up.pt')) {
      setErrorMessage("Invalid email. Use your UP email");
      return;
    }

    if (password.text.isEmpty) {
      setErrorMessage("Password is required");
      return;
    }

    if (confirm_password.text.isEmpty || password.text != confirm_password.text) {
      setErrorMessage("Passwords do not match");
      return;
    }

    try {
      print("Attempting to create user with username: ${username.text}");
      Users newUser = Users(
          userName: username.text,
          userPassword: password.text,
          firstName: firstName.text,
          lastName: lastName.text
      );
      print("User created, attempting to sign up...");
      int result = await db.signup(newUser);
      print("Signup result: $result");
      if (result > 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
      } else {
        setErrorMessage("Signup failed. Please try again.");
      }
    } catch (e) {
      print('Signup error: $e');
      setErrorMessage("An error occurred. Please check logs.");
    }
  }

  void setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
      isSignUpFailed = true;
    });
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
                        const Text('Sign up with your UP email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto-Bold',
                          ),
                        ),
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
                        ),
                        SizedBox(height: 10.0),
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
                        ),
                        SizedBox(height: 10.0),
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
                        SizedBox(height: 20.0),
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
                                }, icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                              )
                          ),
                        ),
                        SizedBox(height: 20.0),
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
                                }, icon: Icon(isVisible_ ? Icons.visibility : Icons.visibility_off),
                              )
                          ),
                        ),
                        SizedBox(height: 10.0),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                                },
                                child: const Text("LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto-Regular',
                                  ),
                                )
                            )
                          ],
                        ),
                        if (isSignUpFailed)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
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
                  if (formKey.currentState!.validate()) {
                    signup();
                  }
                },
                tooltip: 'Sign Up',
                backgroundColor: Colors.white,
                elevation: 6,
                child: const Text('SIGN UP'),
              ),
            )
          ],
        )
    );
  }
}
