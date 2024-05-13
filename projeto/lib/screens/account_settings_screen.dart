import 'package:flutter/material.dart';
import 'package:projeto/JsonModels/users.dart';
import 'edit_profile_screen.dart'; // Ensure this path matches the location of your EditProfileScreen

class AccountSettingsScreen extends StatelessWidget {
  final Users user;

  const AccountSettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
            onTap: () {
              // Navigate to the EditProfileScreen with the current user
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Navigate to notifications settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () {
              // Navigate to language settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            onTap: () {
              // Navigate to theme settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Handle user logout
            },
          ),
        ],
      ),
    );
  }
}
