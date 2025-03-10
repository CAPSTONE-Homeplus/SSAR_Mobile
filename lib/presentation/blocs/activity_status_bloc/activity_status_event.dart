part of 'activity_status_bloc.dart';

abstract class ActivityStatusEvent extends Equatable {
  const ActivityStatusEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivityStatuses extends ActivityStatusEvent {}

class SaveActivityStatus extends ActivityStatusEvent {
  final ActivityStatus activityStatus;

  const SaveActivityStatus({required this.activityStatus});

  @override
  List<Object?> get props => [activityStatus];
}

class ClearAllActivityStatuses extends ActivityStatusEvent {}

class ConnectToHub extends ActivityStatusEvent {}

class DisconnectFromHub extends ActivityStatusEvent {}

class UpdateActivityStatuses extends ActivityStatusEvent {
  final List<ActivityStatus> statuses;

  const UpdateActivityStatuses({required this.statuses});

  @override
  List<Object?> get props => [statuses];
}
