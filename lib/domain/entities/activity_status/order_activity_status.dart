import '../../../data/models/activity_status/order_activity_status_model.dart';

class OrderActivityStatus extends OrderActivityStatusModel {
  OrderActivityStatus({required orderId, required activityStatuses}) : super(orderId: orderId, activityStatuses: activityStatuses);
}