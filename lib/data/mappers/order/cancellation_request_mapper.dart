import '../../../domain/entities/order/cancellation_request.dart';
import '../../models/order/cancellation_request_model.dart';

class CancellationRequestMapper {
  static CancellationRequest toEntity (CancellationRequestModel model) {
    return CancellationRequest(
      cancellationReason: model.cancellationReason,
      refundMethod: model.refundMethod,
      cancelledBy: model.cancelledBy,
    );
  }

  static CancellationRequestModel toModel (CancellationRequest entity) {
    return CancellationRequestModel(
      cancellationReason: entity.cancellationReason,
      refundMethod: entity.refundMethod,
      cancelledBy: entity.cancelledBy,
    );
  }
}