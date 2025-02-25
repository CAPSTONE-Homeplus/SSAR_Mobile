import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/failure.dart';
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart';
import 'package:home_clean/domain/use_cases/equipment_supply/get_equipment_supplies_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main() {
  late MockEquipmentSupplyRepository mockEquipmentRepository;
  late GetEquipmentSuppliesUseCase getEquipmentSuppliesUseCase;

  setUp(() {
    mockEquipmentRepository = MockEquipmentSupplyRepository();
    getEquipmentSuppliesUseCase = GetEquipmentSuppliesUseCase(mockEquipmentRepository);
  });

  final String serviceId = "service_123";
  final String? search = "mop";
  final String? orderBy = "name";
  final int? page = 1;
  final int? size = 10;

  final equipmentList = [
    EquipmentSupply(id: "eq_001", name: "Mop", urlImage: "https://example.com/mop.jpg", status: "active", createdAt: "2022-01-01T00:00:00Z", updatedAt: "2022-01-01T00:00:00Z", serviceId: "service_123", code: "MOP-001"),
    EquipmentSupply(id: "eq_002", name: "Vacuum", urlImage: "https://example.com/vacuum.jpg", status: "active", createdAt: "2022-01-01T00:00:00Z", updatedAt: "2022-01-01T00:00:00Z", serviceId: "service_123", code: "VAC-001"),
  ];


  final baseResponse = BaseResponse<EquipmentSupply>(
    size: 10,
    page: 1,
    totalPages: 1,
    items: equipmentList,
    total: 2,
  );

  group('GetEquipmentSuppliesUseCase Tests', () {
    test('should return BaseResponse<EquipmentSupply> when successful', () async {
      // Arrange
      when(mockEquipmentRepository.getEquipmentSupplies(
        serviceId, search, orderBy, page, size,
      )).thenAnswer((_) async => baseResponse);

      // Act
      final result = await getEquipmentSuppliesUseCase.execute(
        serviceId, search, orderBy, page, size,
      );

      // Assert
      expect(result, isA<Right<Failure, BaseResponse<EquipmentSupply>>>());
      expect(result.isRight(), true);
      expect((result as Right).value, baseResponse);
      verify(mockEquipmentRepository.getEquipmentSupplies(
        serviceId, search, orderBy, page, size,
      )).called(1);
    });

    test('should return ApiFailure when ApiException occurs', () async {
      // Arrange
      const errorMessage = 'API error';
      when(mockEquipmentRepository.getEquipmentSupplies(
        serviceId, search, orderBy, page, size,
      )).thenThrow(ApiFailure(errorMessage));

      // Act
      final result = await getEquipmentSuppliesUseCase.execute(
        serviceId, search, orderBy, page, size,
      );

      // Assert
      result.fold(
            (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).message, errorMessage);
        },
            (_) => fail('Expected Left<ApiFailure>, but got Right'),
      );
      verify(mockEquipmentRepository.getEquipmentSupplies(
        serviceId, search, orderBy, page, size,
      )).called(1);
    });

    test('should return ServerFailure when an unknown error occurs', () async {
      // Arrange
      when(mockEquipmentRepository.getEquipmentSupplies(
        serviceId, search, orderBy, page, size,
      )).thenThrow(Exception('Unknown error'));

      // Act
      final result = await getEquipmentSuppliesUseCase.execute(
        serviceId, search, orderBy, page, size,
      );

      // Assert
      result.fold(
            (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, contains('Lỗi hệ thống:'));
        },
            (_) => fail('Expected Left<ServerFailure>, but got Right'),
      );
      verify(mockEquipmentRepository.getEquipmentSupplies(
        serviceId, search, orderBy, page, size,
      )).called(1);
    });
  });
}
