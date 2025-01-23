abstract class ServiceActivityEvent {}

class GetServiceActivitiesByServiceIdEvent extends ServiceActivityEvent {
  final String serviceId;
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetServiceActivitiesByServiceIdEvent({
    required this.serviceId,
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });
}
