import 'dart:async';
import 'package:home_clean/data/datasource/local/activity_status_local_data_source.dart';
import 'package:home_clean/data/mappers/activity_status/activity_status_mapper.dart';
import 'package:home_clean/domain/entities/activity_status/activity_status.dart';
import 'package:home_clean/domain/repositories/activity_status_repository.dart';

import '../datasource/signalr/activity_status_remote_data_source.dart';

class ActivityStatusRepositoryImpl implements ActivityStatusRepository {
  final ActivityStatusRemoteDataSource remoteDataSource;
  final ActivityStatusLocalDataSource localDataSource;
  final StreamController<List<ActivityStatus>> _controller = StreamController.broadcast();

  ActivityStatusRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> connectToHub() async {
    await remoteDataSource.connectToHub();

    // Lắng nghe dữ liệu từ SignalR
    remoteDataSource.activityStream.listen((data) async {
      final statuses = data.map((e) => ActivityStatusMapper.toEntity(e)).toList();

      // Lưu vào Local Database
      await localDataSource.saveActivityStatuses(statuses);

      // Phát dữ liệu mới qua StreamController
      _controller.add(statuses);
    });
  }

  @override
  Future<void> disconnectFromHub() async {
    await remoteDataSource.disconnectFromHub();
    _controller.close();
  }

  @override
  Future<List<ActivityStatus>> getActivityStatuses() async {
    return (await localDataSource.getActivityStatus())
        .map((e) => ActivityStatusMapper.toEntity(e))
        .toList();
  }

  @override
  Future<void> saveActivityStatus(ActivityStatus activityStatus) async {
    final model = ActivityStatusMapper.toModel(activityStatus);
    await localDataSource.saveActivityStatuses([model]);
  }

  @override
  Future<void> clearAllActivityStatuses() async {
    await localDataSource.clearActivityStatus();
  }

  @override
  Stream<List<ActivityStatus>> get activityStream => _controller.stream;
}
