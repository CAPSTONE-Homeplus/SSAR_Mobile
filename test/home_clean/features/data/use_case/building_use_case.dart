import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/domain/entities/building/building.dart';
import 'package:home_clean/domain/usecases/building/get_buildings_usecase.dart';
import 'package:home_clean/domain/usecases/failure.dart';
import 'package:mockito/mockito.dart';

import '../../../helper/test_helper.mocks.dart';

void main (){
  late MockBuildingRepository mockBuildingRepository;
  late GetBuildingsUsecase getBuildingsUsecase;
  late GetBuildingsParams testParams;
  late Building testBuilding;
  late BaseResponse<Building> testBaseResponse;

  setUp(() {
    mockBuildingRepository = MockBuildingRepository();
    getBuildingsUsecase = GetBuildingsUsecase(mockBuildingRepository);

    // Initialize test data in setUp for reuse
    testParams =  GetBuildingsParams(
      search: 'Building 1',
      orderBy: 'name',
      page: 1,
      size: 10,
    );

    testBuilding =  Building(
      id: '1',
      name: 'Building 1',
      longitude: '1.0',
      latitude: '1.0',
      code: 'B1',
      createdAt: '2025-02-18',
      updatedAt: '2025-02-18',
      hubId: 'hub_1',
      clusterId: 'cluster_1',
      status: 'Active',
    );

    testBaseResponse = BaseResponse<Building>(
        items: [testBuilding],
        total: 1,
        page: 1,
        size: 1,
        totalPages: 1
    );
  });

  group('GetBuildingsUsecase', () {
    test('should return Right(BaseResponse) when repository call is successful', () async {
      // Arrange
      when(mockBuildingRepository.getBuildings(
        testParams.search,
        testParams.orderBy,
        testParams.page,
        testParams.size,
      )).thenAnswer((_) async => testBaseResponse);

      // Act
      final result = await getBuildingsUsecase.call(testParams);

      // Assert
      expect(result, isA<Right<Failure, BaseResponse<Building>>>());
      expect(result, Right(testBaseResponse));
    });

    test('should return Left() when repository call is unsuccessful', () async {
      // Arrange
      when(mockBuildingRepository.getBuildings(
        testParams.search,
        testParams.orderBy,
        testParams.page,
        testParams.size,
      )).thenThrow(Exception('Error'));

      // Act
      final result = await getBuildingsUsecase.call(testParams);

      // Assert
      expect(result, isA<Left<Failure, BaseResponse<Building>>>());
    });
  });
}