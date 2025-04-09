part of 'staff_bloc.dart';

abstract class StaffState extends Equatable {
  const StaffState();

  @override
  List<Object> get props => [];
}

class StaffInitial extends StaffState {}

class StaffLoading extends StaffState {}

class StaffLoaded extends StaffState {
  final Staff staff;

  const StaffLoaded(this.staff);

  @override
  List<Object> get props => [staff];
}

class StaffError extends StaffState {
  final String message;

  const StaffError(this.message);

  @override
  List<Object> get props => [message];
}