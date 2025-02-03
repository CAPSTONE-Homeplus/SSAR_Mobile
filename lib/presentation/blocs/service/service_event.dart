part of 'service_bloc.dart';

abstract class ServiceEvent {}

class GetServicesEvent extends ServiceEvent {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetServicesEvent({this.search, this.orderBy, this.page, this.size});
}

class SaveSelectedServicesEvent extends ServiceEvent {
  final List<String> serviceIds;

  SaveSelectedServicesEvent(this.serviceIds);
}

class LoadSelectedServicesEvent extends ServiceEvent {}

class ClearSelectedServicesEvent extends ServiceEvent {}

// thao tac tren local
class SaveServiceIdsEvent extends ServiceEvent {
  final List<String> ids;

  SaveServiceIdsEvent(this.ids);
}

class GetServiceIdsEvent extends ServiceEvent {}

// thao tac tren state

class AddServiceIdEvent extends ServiceEvent {
  final String id;
  AddServiceIdEvent({required this.id});
}

class RemoveServiceIdEvent extends ServiceEvent {
  final String id;
  RemoveServiceIdEvent({required this.id});
}

class ClearServiceIdsEvent extends ServiceEvent {}
