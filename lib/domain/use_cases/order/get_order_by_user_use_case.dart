import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/order/order.dart';
import '../../repositories/order_repository.dart';

class GetOrderByUserUseCase {
  final OrderRepository _orderRepository;

  GetOrderByUserUseCase(this._orderRepository);

  @override
  Future<Either<Failure, BaseResponse<Orders>>> execute(String? search, String? orderBy, int? page, int? size) async {
    try {
      final result = await _orderRepository.getOrdersByUser(search, orderBy, page, size);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}