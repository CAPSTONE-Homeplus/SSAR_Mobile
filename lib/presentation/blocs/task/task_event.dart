import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrderTasksEvent extends TaskEvent {
  final String orderId;
  final int? page;
  final int? size;

  const FetchOrderTasksEvent({
    required this.orderId,
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [orderId, page, size];
}