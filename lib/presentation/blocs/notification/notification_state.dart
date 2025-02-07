part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String title;
  final String message;

  const NotificationSuccess({required this.title, required this.message});

  @override
  List<Object?> get props => [title, message];
}
