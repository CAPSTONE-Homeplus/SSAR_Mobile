import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_clean/domain/entities/activity_status/activity_status.dart';
import 'package:home_clean/domain/repositories/activity_status_repository.dart';

part 'activity_status_event.dart';
part 'activity_status_state.dart';

class ActivityStatusBloc extends Bloc<ActivityStatusEvent, ActivityStatusState> {
  final ActivityStatusRepository repository;
  StreamSubscription<List<ActivityStatus>>? _activityStreamSubscription;

  ActivityStatusBloc({required this.repository}) : super(ActivityStatusInitial()) {
    on<LoadActivityStatuses>(_onLoadActivityStatuses);
    on<SaveActivityStatus>(_onSaveActivityStatus);
    on<ClearAllActivityStatuses>(_onClearAllActivityStatuses);
    on<ConnectToHub>(_onConnectToHub);
    on<DisconnectFromHub>(_onDisconnectFromHub);

    // Lắng nghe Stream từ Repository
    _activityStreamSubscription = repository.activityStream.listen((statuses) {
      add(LoadActivityStatuses());
    });
  }

  Future<void> _onLoadActivityStatuses(LoadActivityStatuses event, Emitter<ActivityStatusState> emit) async {
    emit(ActivityStatusLoading());
    try {
      final statuses = await repository.getActivityStatuses();
      emit(ActivityStatusLoaded(statuses: statuses));
    } catch (e) {
      emit(ActivityStatusError(message: 'Failed to load statuses'));
    }
  }

  Future<void> _onSaveActivityStatus(SaveActivityStatus event, Emitter<ActivityStatusState> emit) async {
    try {
      await repository.saveActivityStatus(event.activityStatus);
      add(LoadActivityStatuses()); // Load lại danh sách sau khi lưu
    } catch (e) {
      emit(ActivityStatusError(message: 'Failed to save activity status'));
    }
  }

  Future<void> _onClearAllActivityStatuses(ClearAllActivityStatuses event, Emitter<ActivityStatusState> emit) async {
    try {
      await repository.clearAllActivityStatuses();
      emit(ActivityStatusLoaded(statuses: []));
    } catch (e) {
      emit(ActivityStatusError(message: 'Failed to clear statuses'));
    }
  }

  Future<void> _onConnectToHub(ConnectToHub event, Emitter<ActivityStatusState> emit) async {
    try {
      await repository.connectToHub();
    } catch (e) {
      emit(ActivityStatusError(message: 'Failed to connect to hub'));
    }
  }

  Future<void> _onDisconnectFromHub(DisconnectFromHub event, Emitter<ActivityStatusState> emit) async {
    try {
      await repository.disconnectFromHub();
    } catch (e) {
      emit(ActivityStatusError(message: 'Failed to disconnect from hub'));
    }
  }

  @override
  Future<void> close() {
    _activityStreamSubscription?.cancel();
    return super.close();
  }
}
