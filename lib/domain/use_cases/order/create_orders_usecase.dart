import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../entities/order/create_order.dart';
import '../../entities/order/order.dart';
import '../../repositories/order_repository.dart';
import '../base_usecase.dart';
import '../failure.dart';

class CreateOrderUseCase implements UseCase<Orders, SaveOrderParams>{
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, Orders>> call(SaveOrderParams params) async {
    try {
      final result = await repository.createOrder(params.createOrder);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class SaveOrderParams extends Equatable {
  final CreateOrder createOrder;

  const SaveOrderParams({required this.createOrder});

  @override
  List<Object> get props => [createOrder];
}

