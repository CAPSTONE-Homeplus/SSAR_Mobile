import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/constant.dart';
import 'package:home_clean/presentation/blocs/sub_activity/sub_activity_event.dart';
import 'package:home_clean/presentation/blocs/sub_activity/sub_activity_state.dart';

import '../../../domain/use_cases/sub_activity/get_sub_activities_usecase.dart';

class SubActivityBloc extends Bloc<SubActivityEvent, SubActivityState> {
  final GetSubActivitiesUsecase getSubActivitiesUsecase;

  SubActivityBloc({required this.getSubActivitiesUsecase})
      : super(SubActivityInitialState()) {
    on<GetSubActivities>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetSubActivities event,
    Emitter<SubActivityState> emit,
  ) async {
    emit(SubActivityLoadingState());
    try {
      final response = await getSubActivitiesUsecase.execute(
        event.activityId,
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

      emit(SubActivitySuccessState(subActivities: response.items));
    } catch (e) {
      emit(SubActivityErrorState(message: e.toString()));
    }
  }
}
