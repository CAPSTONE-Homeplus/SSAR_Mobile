import 'package:equatable/equatable.dart';

import '../../../core/base/base_model.dart';
import '../../../domain/entities/task/task.dart';

class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final BaseResponse<Task> tasksResponse;

  const TaskLoadedState({required this.tasksResponse});

  @override
  List<Object?> get props => [tasksResponse];
}

class TaskErrorState extends TaskState {
  final String errorMessage;

  const TaskErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}