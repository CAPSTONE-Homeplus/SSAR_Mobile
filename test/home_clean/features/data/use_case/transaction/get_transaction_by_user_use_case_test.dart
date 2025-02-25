import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';
import 'package:home_clean/domain/use_cases/transaction/get_transaction_by_user.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main() {
  late GetTransactionByUserUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionByUserUseCase(mockRepository);
  });

    final mockResponse = BaseResponse<Transaction>(
    size: 10,
    page: 1,
    total: 50,
    totalPages: 5,
    items: [
      Transaction(id: "1", walletId: "1", userId: "1", paymentMethodId: "1", amount: 1000.toString(), type: "1", paymentUrl: "url", note: "note", transactionDate: "2021-10-10", status: "1", createdAt: "2021-10-10", updatedAt: "2021-10-10", code: "code", categoryId: "1", orderId: "1"),
      Transaction(id: "2", walletId: "1", userId: "1", paymentMethodId: "1", amount: 1000.toString(), type: "1", paymentUrl: "url", note: "note", transactionDate: "2021-10-10", status: "1", createdAt: "2021-10-10", updatedAt: "2021-10-10", code: "code", categoryId: "1", orderId: "1"),
    ],
  );

  test('should return transaction list when repository call is successful', () async {
    // Arrange
    when(mockRepository.getTransactionByUser(any, any, any, any))
        .thenAnswer((_) async => mockResponse);

    // Act
    final result = await useCase.call(search: 'search term', orderBy: 'date', page: 1, size: 10);

    // Assert
    expect(result, Right(mockResponse));
    verify(mockRepository.getTransactionByUser('search term', 'date', 1, 10)).called(1);
  });

  test('should return error message when repository throws ApiException', () async {
    // Arrange
    const errorMessage = 'Network error';
    when(mockRepository.getTransactionByUser(any, any, any, any))
        .thenThrow(ApiException(description: errorMessage, code: 500, message: 'Internal server error', timestamp: '2021-10-10'));

    // Act
    final result = await useCase.call(search: null, orderBy: null, page: null, size: null);

    // Assert
    expect(result, Left(errorMessage));
    verify(mockRepository.getTransactionByUser(null, null, null, null)).called(1);
  });

  test('should return default error message when ApiException has null description', () async {
    // Arrange
    when(mockRepository.getTransactionByUser(any, any, any, any))
        .thenThrow(ApiException(description: null, code: 500, message: 'Internal server error', timestamp: '2021-10-10'));

    // Act
    final result = await useCase.call(search: null, orderBy: null, page: null, size: null);

    // Assert
    expect(result, Left('Đã có lỗi xảy ra!'));
    verify(mockRepository.getTransactionByUser(null, null, null, null)).called(1);
  });
}