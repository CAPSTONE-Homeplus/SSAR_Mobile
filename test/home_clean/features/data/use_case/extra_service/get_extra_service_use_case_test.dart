import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/domain/use_cases/extra_service/get_extra_service_use_case.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/failure.dart';
import 'package:home_clean/domain/entities/extra_service/extra_service.dart';
import 'package:home_clean/domain/repositories/extra_service_repository.dart';

import '../../../../helper/test_helper.mocks.dart';


@GenerateMocks([ExtraServiceRepository])  // Tạo file mock tự động
void main() {
  late GetExtraServiceUseCase useCase;
  late MockExtraServiceRepository mockRepository;

  setUp(() {
    mockRepository = MockExtraServiceRepository();
    useCase = GetExtraServiceUseCase(mockRepository);
  });

  const serviceId = '123';
  const search = 'cleaning';
  const orderBy = 'name';
  const page = 1;
  const size = 10;

  final fakeResponse = BaseResponse<ExtraService>(
    size: 10,
    page: 1,
    total: 100,
    totalPages: 10,
    items: [ExtraService(id: '1', name: 'Test Service')],
  );

  test('should return ExtraService list when repository call is successful', () async {
    // Arrange
    when(mockRepository.getExtraServices(serviceId, search, orderBy, page, size))
        .thenAnswer((_) async => fakeResponse);

    // Act
    final result = await useCase.execute(serviceId, search, orderBy, page, size);

    // Assert
    expect(result, Right(fakeResponse));
    verify(mockRepository.getExtraServices(serviceId, search, orderBy, page, size));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ApiFailure when repository throws ApiException', () async {
    // Arrange
    when(mockRepository.getExtraServices(serviceId, search, orderBy, page, size))
      .thenThrow(ApiException(description: 'Failed', code: 500, message: 'Internal Server', timestamp: '2021-10-10'));


    // Act
    final result = await useCase.execute(serviceId, search, orderBy, page, size);

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ApiFailure>());
        expect((failure as ApiFailure).message, 'Failed');
      },
          (_) => fail('Expected Left<ApiFailure>, but got Right'),
    );
    verify(mockRepository.getExtraServices(serviceId, search, orderBy, page, size)).called(1);
  });

  test('should return ServerFailure when an unknown exception occurs', () async {
    // Arrange
    when(mockRepository.getExtraServices(serviceId, search, orderBy, page, size))
        .thenThrow(Exception('Unexpected Error'));

    // Act
    final result = await useCase.execute(serviceId, search, orderBy, page, size);

    // Assert
    result.fold(
          (failure) {
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).message, contains('Unexpected Error'));
      },
          (_) => fail('Expected Left<ServerFailure>, but got Right'),
    );
    verify(mockRepository.getExtraServices(serviceId, search, orderBy, page, size)).called(1);
  });
}
