import '../../../data/laundry_repositories/laundry_order_repo.dart';

abstract class LaundryOrderEvent {}

class CreateLaundryOrderEvent extends LaundryOrderEvent {
  final LaOrderRequest requestData;

  CreateLaundryOrderEvent(this.requestData);
}

class GetLaundryOrderEvent extends LaundryOrderEvent {
  final String orderId;

  GetLaundryOrderEvent(this.orderId);
}