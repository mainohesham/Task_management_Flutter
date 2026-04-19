import '../model/task_model.dart';
import '../service/task_service.dart';
import '../service/task_api_service.dart';

class TaskRepository {
  final TaskDatabaseService _localService;
  final TaskApiService _apiService;

  TaskRepository(this._localService, this._apiService);

  Future<List<Task>> getTasks(int userId) async {
    try {
      // 1️⃣ Try API first
      final tasks = await _apiService.getTasks(userId);
      // 2️⃣ Sync to local cache
      await _syncToLocal(tasks, userId);
      return tasks;
    } catch (e) {
      print('⚠️ API failed, using local cache: $e');
      // 3️⃣ Offline fallback
      return _localService.getTasksByUser(userId);
    }
  }

  Future<void> addTask(Task task) async {
    // 1️⃣ Add on backend → get task with real ID
    final apiTask = await _apiService.addTask(task);
    // 2️⃣ Save locally with real ID
    await _localService.insertTask(apiTask);
  }

  Future<void> updateTask(Task task) async {
    // 1️⃣ Update on backend
    await _apiService.updateTask(task);
    // 2️⃣ Update local cache
    await _localService.updateTask(task);
  }

  Future<void> deleteTask(int id) async {
    // 1️⃣ Delete on backend
    await _apiService.deleteTask(id);
    // 2️⃣ Delete from local cache
    await _localService.deleteTask(id);
  }

  Future<void> toggleComplete(Task task) async {
    // 1️⃣ Toggle on backend → get updated task
    final updatedTask = await _apiService.toggleComplete(task);
    // 2️⃣ Sync to local cache
    await _localService.updateTask(updatedTask);
  }

  Future<void> _syncToLocal(List<Task> tasks, int userId) async {
    // Clear old tasks for this user then insert fresh from API
    await _localService.deleteAllTasksByUser(userId);
    for (final task in tasks) {
      await _localService.insertTask(task);
    }
  }
}