part of 'activity_status_bloc.dart';

abstract class ActivityStatusState extends Equatable {
  @override
  List<Object> get props => [];
}

class ActivityStatusInitial extends ActivityStatusState {}

class ActivityStatusLoading extends ActivityStatusState {}

class ActivityStatusLoaded extends ActivityStatusState {
  final List<ActivityStatus> statuses;
  ActivityStatusLoaded({required this.statuses});

  @override
  List<Object> get props => [statuses];
}

class ActivityStatusError extends ActivityStatusState {
  final String message;
  ActivityStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
