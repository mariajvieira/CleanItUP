import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../JsonModels/users.dart';

class UsersDatabaseHelper {
  final databaseName = "users.db";

  // Define the users table schema
  String usersTable =
      "CREATE TABLE users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";

  // Initialize the users database
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(usersTable);

    });
  }


/*
  // Method to retrieve a user by username
  Future<Users?> getUserByUsername(String username) async {
    final Database db = await initDB();
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'userName = ?',
      whereArgs: [username],
    );
    if (results.isNotEmpty) {
      return Users.fromMap(results.first);
    } else {
      return null;
    }
  }*/


  Future<bool> login(Users user) async {
    final Database db = await initDB();

    // I forgot the password to check
    var result = await db.rawQuery(
        "select * from users where userName = '${user.userName}' AND userPassword = '${user.userPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }
}


