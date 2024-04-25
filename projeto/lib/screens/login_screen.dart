import 'package:flutter/material.dart';
import 'geolocation_screen.dart';
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
    // Simulated login validation
    bool isValidUser = (username.text == 'up12345678@up.pt' && password.text == 'teste');
    if (isValidUser) {
      _navigateToGeoLocationScreen();
    } else {
      if (!username.text.endsWith('@up.pt')) {
        errorMessage = "Invalid username";  // Specific message for username validation
      } else {
        errorMessage = "Username or password is incorrect";  // General error message
      }
      setState(() {
        isLoginFailed = true;
      });
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
        child: SingleChildScrollView(  // Use SingleChildScrollView to avoid overflow when keyboard appears
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (isLoginFailed)
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your UP email',
                    filled: true, // new line
                    fillColor: Colors.white, // new line
                    border: OutlineInputBorder( // new line
                      borderRadius: BorderRadius.circular(8), // new line
                      borderSide: BorderSide.none, // new line
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Add some space between fields
                TextFormField(
                  controller: password,
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    filled: true, // new line
                    fillColor: Colors.white, // new line
                    border: OutlineInputBorder( // new line
                      borderRadius: BorderRadius.circular(8), // new line
                      borderSide: BorderSide.none, // new line
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: login,
                  child: const Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
