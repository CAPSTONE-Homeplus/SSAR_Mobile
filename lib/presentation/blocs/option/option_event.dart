abstract class OptionEvent {}

class GetOptionsEvent extends OptionEvent {
  final String serviceId;
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetOptionsEvent(
      {required this.serviceId,
      this.search,
      this.orderBy,
      this.page,
      this.size});
}
