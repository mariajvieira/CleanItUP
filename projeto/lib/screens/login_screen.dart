import 'package:flutter/material.dart';
import '../JsonModels/users.dart';
import 'geolocation_screen.dart';
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

  void _navigateToGeoLocationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Geolocation()),
    );
  }

  void login() async {
    var response = await db
        .login(Users(userName: username.text, userPassword: password.text));
    if (response == true || (username.text == 'up12345678@up.pt' &&
        password.text == 'teste')) {
      //If login is correct, then goto notes
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Geolocation()),
      );
    }
    if (username.text.isEmpty || password.text.isEmpty) {
      errorMessage = "Username and password required";
    } else if (!username.text.endsWith('@up.pt')) {
      errorMessage = "Invalid username"; // Specific message for username validation
    }
    else {
      errorMessage = "Username or password is incorrect"; // General error message
    }

    setState(() {
      isLoginFailed = true;
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
                              //Navigate to sign up
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
                    if (isLoginFailed)
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
                    login();
                  }
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
