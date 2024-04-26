import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../JsonModels/users.dart';

class UsersDatabaseHelper {
  final String databaseName = "users.db";

  // Initialize the users database
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
        path,
        version: 2,  // Increase version number if schema changes
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT, firstName TEXT, lastName TEXT)"
          );
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          // Check if the table version is older and needs to be upgraded
          if (oldVersion < newVersion) {
            await db.execute("DROP TABLE IF EXISTS users");
            await db.execute(
                "CREATE TABLE users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT, firstName TEXT, lastName TEXT)"
            );
          }
        }
    );
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


  Future<bool> login(String userName, String userPassword) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE userName = ? AND userPassword = ?",
        [userName, userPassword]
    );
    return result.isNotEmpty;
  }

  Future<int> signup(Users user) async {
    final Database db = await initDB();
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Users?> getUserByUsername(String username) async {
    final Database db = await initDB();
    List<Map<String, dynamic>> maps = await db.query(
        'users',
        columns: ['userId', 'userName', 'userPassword', 'firstName', 'lastName'],
        where: 'userName = ?',
        whereArgs: [username]
    );
    if (maps.isNotEmpty) {
      return Users.fromMap(maps.first);
    }
    return null;
  }


}




