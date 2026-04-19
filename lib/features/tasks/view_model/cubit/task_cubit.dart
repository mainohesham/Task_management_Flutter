import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/features/tasks/view_model/cubit/task_state.dart';
import '../../model/model/task_model.dart';
import '../../model/repository/task_repository.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _repository;

  TaskCubit(this._repository) : super(TaskInitial());

  Future<void> loadTasks(int userId) async {
    emit(TaskLoading());
    try {
      final tasks = await _repository.getTasks(userId);

      if (tasks.isEmpty) {
        emit(TaskEmpty());
      } else {
        emit(TaskLoaded(tasks));
      }

    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> addTask(Task task, int userId) async {
    try {
      await _repository.addTask(task);
      await loadTasks(userId);
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> updateTask(Task task, int userId) async {
    try {
      await _repository.updateTask(task);
      await loadTasks(userId);
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> deleteTask(int id, int userId) async {
    try {
      await _repository.deleteTask(id);
      await loadTasks(userId);
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> toggleComplete(Task task, int userId) async {
    try {
      await _repository.updateTask(
        task.copyWith(isCompleted: !task.isCompleted),
      );
      await loadTasks(userId);
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }
}