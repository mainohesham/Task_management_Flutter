import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/task_model.dart';

class TaskDatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    //await deleteDatabase(path);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT NOT NULL,
            priority TEXT NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            userId INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Insert Task
  Future<int> insertTask(Task task) async {
    final db = await database;

    final map = task.toMap();
    map.remove('id');

    return await db.insert('tasks', map);
  }

  // Get Tasks for specific user
  Future<List<Task>> getTasksByUser(int userId) async {
    final db = await database;

    final maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dueDate ASC',
    );

    return maps.map((map) => Task.fromMap(map)).toList();
  }

  // Update Task
  Future<void> updateTask(Task task) async {
    final db = await database;

    if (task.id == null) {
      throw Exception("Task ID is null");
    }

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete Task
  Future<void> deleteTask(int id) async {
    final db = await database;

    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Toggle complete
  Future<void> toggleTask(int id, bool isCompleted) async {
    final db = await database;

    await db.update(
      'tasks',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}