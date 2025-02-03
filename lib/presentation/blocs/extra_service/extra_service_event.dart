abstract class ExtraServiceEvent {}

class GetExtraServices extends ExtraServiceEvent {
  final String serviceId;
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetExtraServices({
    required this.serviceId,
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });
}
