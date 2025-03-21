import 'package:dartz/dartz.dart';
import 'package:home_clean/domain/entities/order/cancellation_request.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../repositories/order_repository.dart';

class CancelOrderUseCase {
  final OrderRepository _orderRepository;

  CancelOrderUseCase(this._orderRepository);

  Future<Either<Failure, bool>> execute(String orderId, CancellationRequest cancellationRequest) async {
    try {
      final result = await _orderRepository.cancelOrder(orderId, cancellationRequest);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}