// In laundry_order_state.dart
import 'package:equatable/equatable.dart';

abstract class CancelOrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CancelLaundryOrderInitial extends CancelOrderState {}
// Add these among your other states
class CancelLaundryOrderLoading extends CancelOrderState {}

class CancelLaundryOrderSuccess extends CancelOrderState {
  final dynamic response;

  CancelLaundryOrderSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CancelLaundryOrderFailure extends CancelOrderState {
  final String errorMessage;

  CancelLaundryOrderFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}