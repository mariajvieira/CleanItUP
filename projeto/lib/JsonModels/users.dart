import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Users {
  String id;
  String firstName;
  String lastName;
  String email;
  bool isRequestSent;

  Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.isRequestSent = false,  // Default false
  });

  factory Users.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Users(
      id: doc.id,
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
    );
  }

  static Future<void> addUserToDatabase(
      String firstName, String lastName, String email, String password) async {
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('Users').doc(userCredential.user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });
    } catch (e) {
      print("Failed to add user: $e");
    }
  }
}
