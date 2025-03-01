part of 'service_bloc.dart';

abstract class ServiceState {}

class ServiceInitialState extends ServiceState {}

class ServiceLoadingState extends ServiceState {}

class ServiceSuccessState extends ServiceState {
  final BaseResponse<Service> services;

  ServiceSuccessState({required this.services});
}

class ServiceErrorState extends ServiceState {
  final String message;

  ServiceErrorState({required this.message});
}

// State cho luu tru danh sach id duoi local
class ServiceIdsSavedState extends ServiceState {}

class ServiceIdsLoadedState extends ServiceState {
  final List<String> ids;

  ServiceIdsLoadedState({required this.ids});
}

class ServiceIdsClearedState extends ServiceState {}


// thao tac tren state

class ServiceIdsState extends ServiceState {
  final List<String> serviceIds;

  ServiceIdsState({required this.serviceIds});
}

class ServiceExceptionState extends ServiceState {
  final String message;

  ServiceExceptionState({required this.message});
}

