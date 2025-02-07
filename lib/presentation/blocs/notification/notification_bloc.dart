import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/notification/initialize_notification_usecase.dart';
import '../../../domain/usecases/notification/show_notification_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final InitializeNotificationUseCase initializeNotificationUseCase;
  final ShowNotificationUseCase showNotificationUseCase;

  NotificationBloc({
    required this.initializeNotificationUseCase,
    required this.showNotificationUseCase,
  }) : super(NotificationInitial()) {
    on<InitializeNotificationEvent>((event, emit) async {
      await initializeNotificationUseCase.call();
    });

    on<ShowNotificationEvent>((event, emit) async {
      await showNotificationUseCase.call(event.title, event.message);
      emit(NotificationSuccess(title: event.title, message: event.message));
    });
  }
}
