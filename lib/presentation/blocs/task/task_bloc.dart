import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/blocs/task/task_event.dart';
import 'package:home_clean/presentation/blocs/task/task_state.dart';

import '../../../data/repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(TaskInitialState()) {
    on<FetchOrderTasksEvent>(_onFetchOrderTasks);
  }

  Future<void> _onFetchOrderTasks(
      FetchOrderTasksEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoadingState());

    try {
      final tasksResponse = await _taskRepository.getOrderTasks(
        event.orderId,
        page: event.page,
        size: event.size,
      );

      emit(TaskLoadedState(tasksResponse: tasksResponse));
    } catch (e) {
      emit(TaskErrorState(errorMessage: e.toString()));
    }
  }
}