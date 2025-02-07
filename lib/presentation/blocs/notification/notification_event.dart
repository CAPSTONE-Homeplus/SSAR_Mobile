part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}


class InitializeNotificationEvent extends NotificationEvent {}

class ShowNotificationEvent extends NotificationEvent {
  final String title;
  final String message;

  const ShowNotificationEvent({required this.title, required this.message});

  @override
  List<Object> get props => [title, message];
}
