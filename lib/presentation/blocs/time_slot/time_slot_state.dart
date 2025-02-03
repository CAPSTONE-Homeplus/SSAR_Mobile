import 'package:home_clean/domain/entities/time_slot/time_slot.dart';

abstract class TimeSlotState {}

class TimeSlotInitial extends TimeSlotState {}

class TimeSlotLoading extends TimeSlotState {}

class TimeSlotLoaded extends TimeSlotState {
  final List<TimeSlot> timeSlots;

  TimeSlotLoaded({required this.timeSlots});
}

class TimeSlotError extends TimeSlotState {
  final String message;

  TimeSlotError({required this.message});
}
