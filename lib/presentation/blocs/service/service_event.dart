abstract class ServiceEvent {}

class GetServicesEvent extends ServiceEvent {
  final String search;
  final String orderBy;
  final int page;
  final int size;

  GetServicesEvent(
      {required this.search,
      required this.orderBy,
      required this.page,
      required this.size});
}
