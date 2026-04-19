import '../model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class AuthService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'users.db');
    //await deleteDatabase(path);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT NOT NULL,
            gender TEXT,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            studentID TEXT NOT NULL,
            academicLevel INTEGER,
            profilePhoto TEXT
          )
        ''');
      },
    );
  }

  // ✅ Get all users
  Future<List<User>> getUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((e) => User.fromMap(e)).toList();
  }

  // ✅ Sign Up
  Future<User> signUp(User user) async {
    final db = await database;

    // check if email exists
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user.email],
    );

    if (existing.isNotEmpty) {
      throw Exception("Email already exists");
    }

    final map = user.toMap();
    map.remove('id');

    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  // ✅ Login
  Future<User> login(String email, String password) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isEmpty) {
      throw Exception("Invalid email or password");
    }

    return User.fromMap(result.first);
  }

  // Get user by id
  Future<User> getUserById(int userId) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (maps.isEmpty) throw Exception('User not found');
    return User.fromMap(maps.first);
  }

// Update user
  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}

