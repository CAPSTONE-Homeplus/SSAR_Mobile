// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:home_clean/core/base/base_model.dart';
// import 'package:home_clean/core/exception/exception_handler.dart';
// import 'package:home_clean/core/exception/failure.dart';
// import 'package:home_clean/domain/entities/building/building.dart';
// import 'package:home_clean/domain/use_cases/building/get_buildings_use_case.dart';
// import 'package:mockito/mockito.dart';
//
// import '../../../../helper/test_helper.mocks.dart';
//
// void main() {
//   late MockBuildingRepository mockBuildingRepository;
//   late GetBuildingsUseCase getBuildingsUseCase;
//
//   setUp(() {
//     mockBuildingRepository = MockBuildingRepository();
//     getBuildingsUseCase = GetBuildingsUseCase(mockBuildingRepository);
//   });
//
//   final params = GetBuildingsParams(
//     search: 'Office',
//     orderBy: 'name',
//     page: 1,
//     size: 10,
//   );
//
//   final buildings = [
//     Building(id: '1', name: 'Building A', longitude: '0', latitude: '0', code: 'A', createdAt: '2021-09-01', updatedAt: '2021-09-01', hubId: '1', clusterId: '1', status: 'active'),
//   ];
//
//   final expectedResponse = BaseResponse<Building>(
//     items: buildings,
//     page: 1,
//     size: 10,
//     total: 2,
//     totalPages: 1,
//   );
//
//   group('GetBuildingsUseCase Tests', () {
//     test('should return BaseResponse<Building> when API call is successful', () async {
//       // Arrange
//       when(mockBuildingRepository.getBuildings(
//         params.search,
//         params.orderBy,
//         params.page,
//         params.size,
//       )).thenAnswer((_) async => expectedResponse);
//
//       // Act
//       final result = await getBuildingsUseCase.execute(params);
//
//       // Assert
//       expect(result, isA<Right<Failure, BaseResponse<Building>>>());
//       expect(result.isRight(), true);
//       expect((result as Right).value, expectedResponse);
//       verify(mockBuildingRepository.getBuildings(
//         params.search,
//         params.orderBy,
//         params.page,
//         params.size,
//       )).called(1);
//     });
//
//     test('should return ApiFailure when API throws an exception', () async {
//       // Arrange
//       const errorMessage = 'API Error';
//       when(mockBuildingRepository.getBuildings(
//         params.search,
//         params.orderBy,
//         params.page,
//         params.size,
//       )).thenThrow(ApiException(description: errorMessage, code: 500, message: 'Internal Server', timestamp: '2021-10-10'));
//
//       // Act
//       final result = await getBuildingsUseCase.execute(params);
//
//       // Assert
//       result.fold(
//             (failure) {
//           expect(failure, isA<ApiFailure>());
//           expect((failure as ApiFailure).message, errorMessage);
//         },
//             (_) => fail('Expected Left<ApiFailure>, but got Right'),
//       );
//       verify(mockBuildingRepository.getBuildings(
//         params.search,
//         params.orderBy,
//         params.page,
//         params.size,
//       )).called(1);
//     });
//
//     test('should return ServerFailure when an unknown exception occurs', () async {
//       // Arrange
//       when(mockBuildingRepository.getBuildings(
//         params.search,
//         params.orderBy,
//         params.page,
//         params.size,
//       )).thenThrow(Exception('Unknown error'));
//
//       // Act
//       final result = await getBuildingsUseCase.execute(params);
//
//       // Assert
//       result.fold(
//             (failure) {
//           expect(failure, isA<ServerFailure>());
//           expect((failure as ServerFailure).message.contains('Lỗi hệ thống'), true);
//         },
//             (_) => fail('Expected Left<ServerFailure>, but got Right'),
//       );
//       verify(mockBuildingRepository.getBuildings(
//         params.search,
//         params.orderBy,
//         params.page,
//         params.size,
//       )).called(1);
//     });
//   });
// }
