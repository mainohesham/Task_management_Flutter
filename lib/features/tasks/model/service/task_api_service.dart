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
        '${ApiConstants.tasks}/$userId',  // GET /tasks/:userId
      );
      final List data = response.data;
      return data.map((json) => Task.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Add Task
  Future<Task> addTask(Task task) async {
    try {
      final response = await _dio.post(
        ApiConstants.tasks,               // POST /tasks
        data: task.toJson(),
      );
      return Task.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Update Task
  Future<Task> updateTask(Task task) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.tasks}/${task.id}', // PUT /tasks/:id
        data: task.toJson(),
      );
      return Task.fromJson(response.data);
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
        '${ApiConstants.tasks}/${task.id}/complete', // PUT /tasks/:id/complete
      );
      return Task.fromJson(response.data);
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