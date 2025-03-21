import 'package:equatable/equatable.dart';

class CancellationRequest extends Equatable {
  final String cancellationReason;
  final String refundMethod;
  final String cancelledBy;

  CancellationRequest({
    required this.cancellationReason,
    required this.refundMethod,
    required this.cancelledBy,
  });


  @override
  List<Object?> get props => [cancellationReason, refundMethod, cancelledBy];
}
