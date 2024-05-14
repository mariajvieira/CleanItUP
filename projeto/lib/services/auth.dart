import 'package:firebase_auth/firebase_auth.dart';
import '../JsonModels/users.dart';

class Auth {
  final FirebaseAuth auth_ = FirebaseAuth.instance;

  // Create user object based on Firebase user
  Users _userFromFirebaseUser(User user, String firstName, String lastName, String userEmail, String userPassword) {
    return Users(
      userId: user.uid,
      firstName: firstName,
      lastName: lastName,
      userEmail: userEmail,
      userPassword: userPassword,
    );
  }

  // Auth change user stream
  Stream<Users?> get user {
    return auth_.authStateChanges()
        .map((User? user) => user != null ? _userFromFirebaseUser(user, '', '', '', '') : null);
  }

  // Sign up user with email and password
  Future<Users?> signUpUser(String email, String password, String firstName, String lastName) async {
    try {
      UserCredential result = await auth_.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        return _userFromFirebaseUser(user, firstName, lastName, email, password);
      }
      return null;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await auth_.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

