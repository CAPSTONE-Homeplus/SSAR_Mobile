import 'package:home_clean/domain/entities/sub_activity/sub_activity.dart';

abstract class SubActivityState {}

class SubActivityInitialState extends SubActivityState {}

class SubActivityLoadingState extends SubActivityState {}

class SubActivityErrorState extends SubActivityState {
  final String message;

  SubActivityErrorState({required this.message});
}

class SubActivitySuccessState extends SubActivityState {
  final List<SubActivity> subActivities;

  SubActivitySuccessState({required this.subActivities});
}
