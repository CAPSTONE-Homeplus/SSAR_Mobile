import '../../../data/laundry_repositories/laundry_order_repo.dart';

abstract class LaundryOrderState {}

class LaundryOrderInitial extends LaundryOrderState {}

class LaundryOrderLoading extends LaundryOrderState {}

class CreateLaundrySuccess extends LaundryOrderState {
  final LaundryOrderDetailModel order;
  CreateLaundrySuccess(this.order);
}


class LaundryOrderFailure extends LaundryOrderState {
  final String errorMessage;

  LaundryOrderFailure(this.errorMessage);
}

class GetLaundrySuccess extends LaundryOrderState {
  final LaundryOrderDetailModel order;

  GetLaundrySuccess(this.order);
}
