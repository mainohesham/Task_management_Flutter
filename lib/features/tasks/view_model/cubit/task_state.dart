import 'package:equatable/equatable.dart';

import '../../model/model/task_model.dart';


abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskEmpty extends TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskFailure extends TaskState {
  final String message;
  TaskFailure(this.message);

  @override
  List<Object?> get props => [message];
}