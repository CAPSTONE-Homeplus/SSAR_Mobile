part of 'staff_bloc.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();

  @override
  List<Object> get props => [];
}

class GetStaffById extends StaffEvent {
  final String staffId;

  const GetStaffById(this.staffId);

  @override
  List<Object> get props => [staffId];
}