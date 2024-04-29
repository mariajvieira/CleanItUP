import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../JsonModels/users.dart';
import '../JsonModels/recyclingBin.dart';

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
          await db.execute(
              "CREATE TABLE recycling_bins ("
                  "bin_id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "bin_latitude REAL NOT NULL, "
                  "bin_longitude REAL NOT NULL, "
                  "clean INTEGER NOT NULL, "
                  "full INTEGER NOT NULL"
                  ")"
          );
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          // Check if the table version is older and needs to be upgraded
          if (oldVersion < newVersion) {
            await db.execute("DROP TABLE IF EXISTS users");
            await db.execute("DROP TABLE IF EXISTS recycling_bins");
            await db.execute(
                "CREATE TABLE users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT, firstName TEXT, lastName TEXT)"
            );
            await db.execute(
                "CREATE TABLE recycling_bins ("
                    "bin_id INTEGER PRIMARY KEY AUTOINCREMENT, "
                    "bin_latitude REAL NOT NULL, "
                    "bin_longitude REAL NOT NULL, "
                    "clean INTEGER NOT NULL, "
                    "full INTEGER NOT NULL"
                    ")"
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

  Future<int> insertRecyclingBin(RecyclingBin bin) async {
    final Database db = await initDB();
    return await db.insert('recycling_bins', bin.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<RecyclingBin>> getAllRecyclingBins() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('recycling_bins');
    return List.generate(maps.length, (i) {
      return RecyclingBin(
        bin_id: maps[i]['bin_id'],
        bin_latitude: maps[i]['bin_latitude'],
        bin_longitude: maps[i]['bin_longitude'],
        clean: maps[i]['clean'],
        full: maps[i]['full'],
      );
    });
  }

}




