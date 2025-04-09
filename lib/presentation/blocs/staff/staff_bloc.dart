import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:home_clean/domain/repositories/order_repository.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../domain/entities/staff/staff.dart';

part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final OrderRepository orderRepository;

  StaffBloc({required this.orderRepository}) : super(StaffInitial()) {
    on<GetStaffById>(_onGetStaffById);
  }

  Future<void> _onGetStaffById(GetStaffById event, Emitter<StaffState> emit) async {
    emit(StaffLoading());

    try {
      final Staff staff = await orderRepository.getStaffById(event.staffId);
      emit(StaffLoaded(staff));
    } on ApiException catch (e) {
      emit(StaffError(e.toString()));
    }
  }
}