import '../../../domain/entities/activity_status/order_activity_status.dart';
import '../../models/activity_status/order_activity_status_model.dart';
import 'activity_status_mapper.dart';

class OrderActivityStatusMapper {
  /// Chuyển từ `OrderActivityStatusModel` sang `OrderActivityStatusEntity`
  static OrderActivityStatus toEntity(OrderActivityStatusModel model) {
    return OrderActivityStatus(
      orderId: model.orderId,
      activityStatuses: ActivityStatusMapper.listToEntity(model.activityStatuses),
    );
  }
}
