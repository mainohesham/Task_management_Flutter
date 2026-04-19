import 'package:dio/dio.dart';
import '../../../../core/api_constants/api_constants.dart';
import '../../../../core/dio_client/dio_client.dart';
import '../model/task_model.dart';

class TaskApiService {
  final Dio _dio = DioClient.instance;

  // ✅ Get Tasks by userId
  Future<List<Task>> getTasks(int userId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.tasks}/$userId',
      );
      print('🔍 TASKS RESPONSE: ${response.data}');
      final List data = response.data['data'];
      // ✅ pass userId manually to each task
      return data.map((json) {
        final task = Task.fromJson(json);
        return task.copyWith(userId: userId); // ← inject real userId
      }).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Add Task
  Future<Task> addTask(Task task) async {
    try {
      final response = await _dio.post(
        ApiConstants.tasks,
        data: task.toJson(),
      );
      print('🔍 ADD TASK RESPONSE: ${response.data}');
      // ✅ backend only returns task_id → build task manually
      final taskId = response.data['task_id'];
      return task.copyWith(id: taskId);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Update Task
  Future<Task> updateTask(Task task) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.tasks}/${task.id}',
        data: task.toJson(),
      );
      print('🔍 UPDATE TASK RESPONSE: ${response.data}');
      // ✅ backend returns no task data → return same task
      if (response.data['status'] == 'success') {
        return task; // ← return same task, already has correct data
      }
      throw Exception(response.data['message']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Delete Task
  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete(
        '${ApiConstants.tasks}/$id',      // DELETE /tasks/:id
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Mark Task as Complete
  Future<Task> toggleComplete(Task task) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.tasks}/${task.id}/complete',
      );
      print('🔍 TOGGLE COMPLETE RESPONSE: ${response.data}');
      // ✅ backend returns no task data → return toggled task
      if (response.data['status'] == 'success') {
        return task.copyWith(isCompleted: !task.isCompleted); // ← toggle locally
      }
      throw Exception(response.data['message']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Error Handler
  Exception _handleError(DioException e) {
    if (e.response != null) {
      final msg = e.response?.data['message'] ??
          e.response?.data['error'] ??
          'Something went wrong';
      return Exception(msg);
    }
    return Exception('No internet connection');
  }
}