import '../model/task_model.dart';
import '../service/task_service.dart';

class TaskRepository {
  final TaskDatabaseService _service;
  TaskRepository(this._service);

  Future<List<Task>> getTasks(int userId) =>
      _service.getTasksByUser(userId);

  Future<int> addTask(Task task) => _service.insertTask(task);
  Future<void> updateTask(Task task) => _service.updateTask(task);
  Future<void> deleteTask(int id) => _service.deleteTask(id);
}