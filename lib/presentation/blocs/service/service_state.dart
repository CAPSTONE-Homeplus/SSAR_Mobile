import 'package:home_clean/domain/entities/service.dart';

abstract class ServiceState {}

class ServiceInitialState extends ServiceState {}

class ServiceLoadingState extends ServiceState {}

class ServiceSuccessState extends ServiceState {
  final List<Service> services;

  ServiceSuccessState({required this.services});
}

class ServiceErrorState extends ServiceState {
  final String message;

  ServiceErrorState({required this.message});
}
