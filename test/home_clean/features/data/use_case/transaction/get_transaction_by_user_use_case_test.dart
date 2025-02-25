import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/core/exception/failure.dart';
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

  const search = 'order123';
  const orderBy = 'date';
  const page = 1;
  const size = 10;

  final fakeResponse = BaseResponse<Transaction>(
    size: 10,
    page: 1,
    total: 100,
    totalPages: 10,
    items: [Transaction(id: '1', walletId: '1', userId: '1', paymentMethodId: '1', amount: 1000.toString(), type: '1', paymentUrl: 'url', note: 'note', transactionDate: '2021-10-10', status: '1', createdAt: '2021-10-10', updatedAt: '2021-10-10', code: 'code', categoryId: '1', orderId: '1')],
  );

  test('should return transaction list when repository call is successful', () async {
    // Arrange
    when(mockRepository.getTransactionByUser(search, orderBy, page, size))
        .thenAnswer((_) async => fakeResponse);

    // Act
    final result = await useCase.call(
      search: search,
      orderBy: orderBy,
      page: page,
      size: size,
    );

    // Assert
    expect(result, Right(fakeResponse));
    verify(mockRepository.getTransactionByUser(search, orderBy, page, size));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ApiFailure when repository throws ApiException', () async {
    // Arrange
    when(mockRepository.getTransactionByUser(search, orderBy, page, size))
        .thenThrow(ApiException(description: 'API Error', code: 500, message: 'Internal Server', timestamp: '2024-02-25'));

    // Act
    final result = await useCase.call(
      search: search,
      orderBy: orderBy,
      page: page,
      size: size,
    );

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ApiFailure>());
        expect((failure as ApiFailure).message, contains('API Error'));
      },
          (_) => fail('Expected Left<ApiFailure>, but got Right'),
    );
    verify(mockRepository.getTransactionByUser(search, orderBy, page, size)).called(1);
  });

  test('should return ServerFailure when an unknown exception occurs', () async {
    // Arrange
    when(mockRepository.getTransactionByUser(search, orderBy, page, size))
        .thenThrow(Exception('Unexpected Error'));

    // Act
    final result = await useCase.call(
      search: search,
      orderBy: orderBy,
      page: page,
      size: size,
    );

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).message, contains('Unexpected Error'));
      },
          (_) => fail('Expected Left<ServerFailure>, but got Right'),
    );
    verify(mockRepository.getTransactionByUser(search, orderBy, page, size)).called(1);
  });
}