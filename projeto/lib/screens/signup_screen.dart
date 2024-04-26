import 'package:flutter/material.dart';
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
  String errorMessage = "Username or password is incorrect";  // Default error message

  bool isVisible = false;
  bool isVisible_ = false;
  bool isSignUpFailed = false;
  final db = UsersDatabaseHelper();

  void signup() async {
    if (username.text.isEmpty || password.text.isEmpty || confirm_password.text.isEmpty) {
      setState(() {
        errorMessage = "Fill all required fields";
        isSignUpFailed = true;
      });
      return;
    } else if (password.text != confirm_password.text) {
      setState(() {
        errorMessage = "Passwords do not match";
        isSignUpFailed = true;
      });
      return;
    } else if (!username.text.endsWith('@up.pt')) {
      setState(() {
        errorMessage = "Invalid username";
        isSignUpFailed = true;
      });
      return;
    }
    int result = await db.signup(Users(userName: username.text, userPassword: password.text));

    if (result > 0) {
      // Signup successful, navigate to login screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      // Signup failed
      setState(() {
        errorMessage = "Signup failed. Please try again.";
        isSignUpFailed = true;
      });
    }
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
          child: SingleChildScrollView(  // Use SingleChildScrollView to avoid overflow when keyboard appears
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
                        const Text('Sign up with up email',
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
                        const SizedBox(height: 20.0), // Add some space between fields
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
                        const SizedBox(height: 20.0), // Add some space between fields
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
                              hintText: 'Confirm password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible_ = !isVisible_;
                                  });
                                }, icon: Icon(isVisible_? Icons.visibility : Icons.visibility_off),
                              )
                          ),
                        ),
                        const SizedBox(height: 10.0,),
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
                                  //Navigate to sign up
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()));
                                },
                                child: const Text("LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto-Regular',
                                  ),))
                          ],
                        ),
                        const SizedBox(height: 10.0,),

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
                tooltip: 'Increment',
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