class Users {
  final int? userId;
  final String userName;
  final String userPassword;

  Users({
    this.userId,
    required this.userName,
    required this.userPassword,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    userId: json["userID"],
    userName: json["userName"],
    userPassword: json["userPassword"],
  );

  Map<String, dynamic> toMap() => {
    "userID": userId,
    "userName": userName,
    "userPassword": userPassword,
  };
}