import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/order/order.dart';
import '../../repositories/order_repository.dart';

class GetOrderUseCase {
  final OrderRepository _orderRepository;

  GetOrderUseCase(this._orderRepository);

  @override
  Future<Either<Failure, Orders>> execute(String orderId) async {
    try {
      final result = await _orderRepository.getOrder(orderId);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}