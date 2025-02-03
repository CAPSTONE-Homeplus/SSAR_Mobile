import 'package:home_clean/domain/entities/service_activity/service_activity.dart';

abstract class ServiceActivityState {}

class ServiceActivityInitialState extends ServiceActivityState {}

class ServiceActivityLoadingState extends ServiceActivityState {}

class ServiceActivitySuccessState extends ServiceActivityState {
  final List<ServiceActivity> serviceActivities;

  ServiceActivitySuccessState({required this.serviceActivities});
}

class ServiceActivityErrorState extends ServiceActivityState {
  final String message;

  ServiceActivityErrorState({required this.message});
}
