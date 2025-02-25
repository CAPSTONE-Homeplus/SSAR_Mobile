import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';
import 'package:home_clean/domain/use_cases/transaction/get_transaction_by_wallet_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main (){
  late MockTransactionRepository mockRepository;
  late GetTransactionByWalletUseCase useCase;


  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionByWalletUseCase(mockRepository);
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
    when(mockRepository.getTransactionByUserWallet(any, any, any, any, any))
        .thenAnswer((_) async => mockResponse);

    // Act
    final result = await useCase.call('walletId', 'search term', 'date', 1, 10);

    // Assert
    expect(result, Right(mockResponse));
    verify(mockRepository.getTransactionByUserWallet('walletId', 'search term', 'date', 1, 10)).called(1);
  });

  test('should return error message when repository throws ApiException', () async {
    // Arrange
    const errorMessage = 'Network error';
    when(mockRepository.getTransactionByUserWallet(any, any, any, any, any))
        .thenThrow(ApiException(description: errorMessage, code: 500, message: 'Internal server error', timestamp: '2021-10-10'));

    // Act
    final result = await useCase.call('walletId', null, null, null, null);

    // Assert
    expect(result, Left(errorMessage));
    verify(mockRepository.getTransactionByUserWallet('walletId', null, null, null, null)).called(1);
  });

  test('should return default error message when ApiException has null description', () async {
    // Arrange
    when(mockRepository.getTransactionByUserWallet(any, any, any, any, any))
        .thenThrow(ApiException(description: null, code: 500, message: 'Internal server error', timestamp: '2021-10-10'));

    // Act
    final result = await useCase.call('walletId', null, null, null, null);

    // Assert
    expect(result, Left('Đã có lỗi xảy ra!'));
    verify(mockRepository.getTransactionByUserWallet('walletId', null, null, null, null)).called(1);
  });

}