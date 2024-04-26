class Users {
  int? userId;
  String userName;
  String userPassword;
  String firstName;
  String lastName;

  Users({this.userId, required this.userName, required this.userPassword, required this.firstName, required this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userPassword': userPassword,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['userId'],
      userName: map['userName'],
      userPassword: map['userPassword'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }
}