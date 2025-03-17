part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

class RefreshNotificationsEvent extends NotificationEvent {}

class NewNotificationReceivedEvent extends NotificationEvent {
  final NotificationEntity notification;

  NewNotificationReceivedEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class ConnectToHubEvent extends NotificationEvent {}

class DisconnectFromHubEvent extends NotificationEvent {}
