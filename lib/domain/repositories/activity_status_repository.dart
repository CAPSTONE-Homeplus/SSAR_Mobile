
import '../entities/activity_status/activity_status.dart';

abstract class ActivityStatusRepository {
  Future<void> connectToHub();
  Future<void> disconnectFromHub();
  Future<List<ActivityStatus>> getActivityStatuses();
  Future<void> saveActivityStatus(ActivityStatus activityStatus);
  Future<void> clearAllActivityStatuses();
  Stream<List<ActivityStatus>> get activityStream;
}


