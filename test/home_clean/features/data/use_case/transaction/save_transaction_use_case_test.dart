import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/core/exception/failure.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';
import 'package:home_clean/domain/use_cases/transaction/save_transaction_use_case.dart';

import '../../../../helper/test_helper.mocks.dart';

void main() {
  late SaveTransactionUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = SaveTransactionUseCase(mockRepository);
  });

  final createTransaction = CreateTransaction(
    walletId: 'wallet_123',
    userId: 'user_123',
    paymentMethodId: 'method_123',
    amount: '1000',
    note: 'note',
    orderId: 'order_123',
  );
  final transaction = Transaction(id: '1', walletId: '1', userId: '1', paymentMethodId: '1', amount: 1000.toString(), type: '1', paymentUrl: 'url', note: 'note', transactionDate: '2021-10-10', status: '1', createdAt: '2021-10-10', updatedAt: '2021-10-10', code: 'code', categoryId: '1', orderId: '1');

  final params = SaveTransactionParams(transaction: createTransaction);

  test('should return Transaction when repository call is successful', () async {
    // Arrange
    when(mockRepository.saveTransaction(createTransaction)).thenAnswer((_) async => transaction);

    // Act
    final result = await useCase.call(params);

    // Assert
    expect(result, Right(transaction));
    verify(mockRepository.saveTransaction(createTransaction)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ApiFailure when repository throws ApiException', () async {
    // Arrange
    when(mockRepository.saveTransaction(createTransaction))
        .thenThrow(ApiException(description: 'API Error', code: 500, message: 'Internal Server', timestamp: '2024-02-25'));

    // Act
    final result = await useCase.call(params);

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ApiFailure>());
        expect((failure as ApiFailure).message, contains('API Error'));
      },
          (_) => fail('Expected Left<ApiFailure>, but got Right'),
    );
    verify(mockRepository.saveTransaction(createTransaction)).called(1);
  });

  test('should return ServerFailure when an unknown exception occurs', () async {
    // Arrange
    when(mockRepository.saveTransaction(createTransaction))
        .thenThrow(Exception('Unexpected Error'));

    // Act
    final result = await useCase.call(params);

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).message, contains('Unexpected Error'));
      },
          (_) => fail('Expected Left<ServerFailure>, but got Right'),
    );
    verify(mockRepository.saveTransaction(createTransaction)).called(1);
  });
}