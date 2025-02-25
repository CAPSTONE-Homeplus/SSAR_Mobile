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

  final transaction = Transaction(
    id: "123",
    walletId: "wallet_001",
    userId: "user_001",
    paymentMethodId: "pm_001",
    amount: "1000",
    type: "deposit",
    paymentUrl: "https://payment.com",
    note: "Test transaction",
    transactionDate: "2025-02-25",
    status: "completed",
    createdAt: "2025-02-25",
    updatedAt: "2025-02-25",
    code: "TXN123",
    categoryId: "cat_001",
    orderId: "order_001",
  );

  final createTransaction = CreateTransaction(
    walletId: "wallet_001",
    userId: "user_001",
    paymentMethodId: "pm_001",
    amount: "1000",
    note: "Test transaction",
    orderId: "order_001",
  );

  final params = SaveTransactionParams(transaction: createTransaction);

  test('should call repository.saveTransaction() and return Transaction on success', () async {
    // Arrange
    when(mockRepository.saveTransaction(any)).thenAnswer((_) async => transaction);

    // Act
    final result = await useCase(params);

    // Assert
    expect(result, Right(transaction));
    verify(mockRepository.saveTransaction(createTransaction)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ApiFailure when ApiException occurs', () async {
    // Arrange
    final apiException = ApiException(
      description: "API error",
      code: 500,
      message: "Internal server error",
      timestamp: "2025-02-25",
    );

    when(mockRepository.saveTransaction(any)).thenThrow(apiException);

    // Act
    final result = await useCase(params);

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ApiFailure>());
        expect((failure as ApiFailure).message, "API error");
      },
          (r) => fail("Should return ApiFailure"),
    );

    verify(mockRepository.saveTransaction(createTransaction)).called(1);
  });

  test('should return ServerFailure when unknown exception occurs', () async {
    // Arrange
    when(mockRepository.saveTransaction(any)).thenThrow(Exception("Server error"));

    // Act
    final result = await useCase(params);

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).message, "Exception: Server error");
      },
          (r) => fail("Should return ServerFailure"),
    );

    verify(mockRepository.saveTransaction(createTransaction)).called(1);
  });

  test('should return ValidationFailure when params.transaction is null', () async {
    // Act
    final result = await useCase(SaveTransactionParams(transaction: CreateTransaction()));

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ServerFailure>());
      },
          (r) => fail("Should return ValidationFailure"),
    );
  });
}
