part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

class RefreshNotificationsEvent extends NotificationEvent {}

class MarkAsReadEvent extends NotificationEvent {
  final String notificationId;

  MarkAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;

  DeleteNotificationEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class NewNotificationReceivedEvent extends NotificationEvent {
  final NotificationEntity notification;

  NewNotificationReceivedEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class ConnectToHubEvent extends NotificationEvent {}

class DisconnectFromHubEvent extends NotificationEvent {}
