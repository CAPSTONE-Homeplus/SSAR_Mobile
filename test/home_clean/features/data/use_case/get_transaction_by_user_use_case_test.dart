// import 'package:flutter_test/flutter_test.dart';
// import 'package:home_clean/domain/use_cases/transaction/get_transaction_by_user.dart';
// import 'package:mockito/mockito.dart';
// import 'package:dartz/dartz.dart';
// import 'package:home_clean/core/base/base_model.dart';
// import 'package:home_clean/core/exception/exception_handler.dart';
// import 'package:home_clean/domain/entities/transaction/transaction.dart';
// import 'package:home_clean/domain/repositories/transaction_repository.dart';
//
// class MockTransactionRepository extends Mock implements TransactionRepository {}
//
// void main() {
//   late GetTransactionByUserUseCase useCase;
//   late MockTransactionRepository mockTransactionRepository;
//
//   setUp(() {
//     mockTransactionRepository = MockTransactionRepository();
//     useCase = GetTransactionByUserUseCase(mockTransactionRepository);
//   });
//
//   const String searchQuery = "test";
//   const String orderBy = "date";
//   const int page = 1;
//   const int size = 10;
//
//   final mockResponse = BaseResponse<Transaction>(
//     size: 10,
//     page: 1,
//     total: 50,
//     totalPages: 5,
//     items: [
//       Transaction(id: "1", walletId: "1", userId: "1", paymentMethodId: "1", amount: 1000.toString(), type: "1", paymentUrl: "url", note: "note", transactionDate: "2021-10-10", status: "1", createdAt: "2021-10-10", updatedAt: "2021-10-10", code: "code", categoryId: "1", orderId: "1"),
//       Transaction(id: "2", walletId: "1", userId: "1", paymentMethodId: "1", amount: 1000.toString(), type: "1", paymentUrl: "url", note: "note", transactionDate: "2021-10-10", status: "1", createdAt: "2021-10-10", updatedAt: "2021-10-10", code: "code", categoryId: "1", orderId: "1"),
//     ],
//   );
//
//
//   test('should return transaction data when the call is successful', () async {
//     // Arrange
//     when(mockTransactionRepository.getTransactionByUser(searchQuery, orderBy, page, size))
//         .thenAnswer((_) async => Right(mockResponse.items));
//
//
//     // Act
//     final result = await useCase.call(searchQuery, orderBy, page, size);
//
//     // Assert
//     expect(result, Right(mockResponse));
//     verify(mockTransactionRepository.getTransactionByUser(searchQuery, orderBy, page, size)).called(1);
//     verifyNoMoreInteractions(mockTransactionRepository);
//   });
//
//   test('should return an error message when an ApiException occurs', () async {
//     // Arrange
//     when(mockTransactionRepository.getTransactionByUser(searchQuery, orderBy, page, size))
//         .thenThrow(ApiException(description: "Lỗi API", code: 400, message: 'Bad Request', timestamp: '2021-10-10'));
//
//     // Act
//     final result = await useCase.call(searchQuery, orderBy, page, size);
//
//     // Assert
//     expect(result, Left("Lỗi API"));
//     verify(mockTransactionRepository.getTransactionByUser(searchQuery, orderBy, page, size)).called(1);
//     verifyNoMoreInteractions(mockTransactionRepository);
//   });
// }
