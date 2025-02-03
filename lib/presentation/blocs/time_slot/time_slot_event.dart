abstract class TimeSlotEvent {}

class GetTimeSlotEvents extends TimeSlotEvent {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetTimeSlotEvents({
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });
}
