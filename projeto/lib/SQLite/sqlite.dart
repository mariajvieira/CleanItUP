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
      version: 2, // Increase version number if schema changes
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  void _createDb(Database db, int version) async {
    try {
    print('Creating database with version $version');
    await db.execute(
        "CREATE TABLE IF NOT EXISTS users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT, firstName TEXT, lastName TEXT)"
    );
    await db.execute(
        "CREATE TABLE IF NOT EXISTS recycling_bins (bin_id INTEGER PRIMARY KEY AUTOINCREMENT, bin_latitude REAL NOT NULL, bin_longitude REAL NOT NULL, clean INTEGER NOT NULL, full INTEGER NOT NULL)"
    );
    await db.execute(
        "CREATE TABLE IF NOT EXISTS friends (friend_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, friend_user_id INTEGER, FOREIGN KEY(user_id) REFERENCES users(userId), FOREIGN KEY(friend_user_id) REFERENCES users(userId))"
    );
    await db.execute(
        "CREATE TABLE IF NOT EXISTS posts (post_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, content TEXT, post_date DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(user_id) REFERENCES users(userId))"
    );
    print("Database tables created!");
    } catch (e) {
      print("Error creating database: $e");
    }
  }

  void _upgradeDb(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from $oldVersion to $newVersion');
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE IF EXISTS users");
      await db.execute("DROP TABLE IF EXISTS recycling_bins");
      await db.execute("DROP TABLE IF EXISTS friends");
      await db.execute("DROP TABLE IF EXISTS posts");
      _createDb(db, newVersion);
    }
  }



  Future<bool> login(String userName, String userPassword) async {
    final Database db = await initDB();
    try {
      var result = await db.rawQuery(
          "SELECT * FROM users WHERE userName = ? AND userPassword = ?",
          [userName, userPassword]
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }


  Future<int> signup(Users user) async {
    final Database db = await initDB();
    try {
      return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Signup error: $e');
      return -1;
    }
  }

  Future<Users?> getUserByUsername(String username) async {
    final Database db = await initDB();
    try {
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
    } catch (e) {
      print('Error fetching user by username: $e');
      return null;
    }
  }

  Future<int> insertRecyclingBin(RecyclingBin bin) async {
    final Database db = await initDB();
    try {
      return await db.insert('recycling_bins', bin.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error inserting recycling bin: $e');
      return -1;
    }
  }


  Future<List<RecyclingBin>> getAllRecyclingBins() async {
    final Database db = await initDB();
    try {
      final List<Map<String, dynamic>> maps = await db.query('recycling_bins');
      return List.generate(maps.length, (i) {
        return RecyclingBin.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error retrieving all recycling bins: $e');
      return [];
    }
  }
  Future<int> countUserFriends(int userId) async {
    final Database db = await initDB();
    final result = await db.rawQuery(
        'SELECT COUNT(*) FROM friends WHERE user_id = ?',
        [userId]
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countUserPosts(int userId) async {
    final Database db = await initDB();
    final result = await db.rawQuery(
        'SELECT COUNT(*) FROM posts WHERE user_id = ?',
        [userId]
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> addPost(int userId, String content, double? lat, double? lon, {String? imagePath}) async {
    final Database db = await initDB();
    final postMap = {
      'user_id': userId,
      'content': content,
      'latitude': lat,
      'longitude': lon,
      'image_path': imagePath, // Optionally include image path if provided
    };
    try {
      return await db.insert('posts', postMap, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error adding post: $e');
      return -1; // Return -1 to indicate an error
    }
  }

  Future<List<Map<String, dynamic>>> getUserPosts(int userId) async {
    final Database db = await initDB();
    List<Map<String, dynamic>> posts = await db.query(
        'posts',
        where: 'user_id = ?',
        whereArgs: [userId]
    );
    return posts;
  }

  Future<List<Users>> searchUsersByName(String name) async {
    final Database db = await initDB();
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'firstName LIKE ? OR lastName LIKE ?',
      whereArgs: ['%$name%', '%$name%'],
    );
    return result.map((map) => Users.fromMap(map)).toList();
  }

}
