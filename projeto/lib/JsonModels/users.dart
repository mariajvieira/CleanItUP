class Users {
  int? userId;
  String userName;
  String userPassword;
  String firstName;
  String lastName;

  Users({
    this.userId,
    required this.userName,
    required this.userPassword,
    required this.firstName,
    required this.lastName,
  });

  // Full name computed property
  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toMap() {
    var map = {
      'userName': userName,
      'userPassword': userPassword,
      'firstName': firstName,
      'lastName': lastName,
    };

    // Include userId if it's not null (useful for updates)
    if (userId != null) {
      map['userId'] = userId as String;
    }

    return map;
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['userId'] as int?, // Cast to int? since userId can be null
      userName: map['userName'] as String,
      userPassword: map['userPassword'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
    );
  }
}
