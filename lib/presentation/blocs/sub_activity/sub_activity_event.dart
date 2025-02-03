abstract class SubActivityEvent {}

class GetSubActivities extends SubActivityEvent {
  final String activityId;
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetSubActivities({
    required this.activityId,
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });
}
