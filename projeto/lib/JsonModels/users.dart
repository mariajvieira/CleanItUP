
class Users {

  String? userId;
  String userEmail;
  String userPassword;
  String firstName;
  String lastName;

  Users({this.userId, required this.userEmail, required this.userPassword, required this.firstName, required this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'userPassword': userPassword,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['userId'],
      userEmail: map['userEmail'],
      userPassword: map['userPassword'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }
}