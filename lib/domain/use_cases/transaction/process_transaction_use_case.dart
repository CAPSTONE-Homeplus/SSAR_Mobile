// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../../core/base/base_usecase.dart';
// import '../../../core/exception/exception_handler.dart';
// import '../../entities/transaction/create_transaction.dart';
// import '../../entities/transaction/transaction.dart';
// import '../../repositories/transaction_repository.dart';
// import '../../../core/exception/failure.dart';
//
// class ProcessTransactionUseCase {
//   final TransactionRepository repository;
//
//   ProcessTransactionUseCase(this.repository);
//
//   Future<Either<String, Transaction>> call(ProcessTransactionParams params) async {
//     try {
//       final result = await repository.processTransactionWithOrder(params.transaction);
//       return Right(result);
//     } on ApiException catch (e) {
//       print('API Exception: ${e.description}');
//       return Left(e.description ?? 'Đã có lỗi xảy ra!');
//     }
//   }
// }
//
// class ProcessTransactionParams extends Equatable {
//   final CreateTransaction transaction;
//
//   const ProcessTransactionParams({required this.transaction});
//
//   @override
//   List<Object> get props => [transaction];
// }