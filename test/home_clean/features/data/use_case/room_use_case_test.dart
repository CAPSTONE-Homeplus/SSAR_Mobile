import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/exception/failure.dart';
import 'package:home_clean/domain/use_cases/room/get_rooms_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:home_clean/domain/entities/room/room.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../helper/test_helper.mocks.dart';

void main() {
  late MockRoomRepository mockRoomRepository;
  late GetRoomsUseCase getRoomsUseCase;
  late GetRoomsParams testParams;
  late Room testRoom;
  late BaseResponse<Room> testBaseResponse;

  setUp(() {
    mockRoomRepository = MockRoomRepository();
    getRoomsUseCase = GetRoomsUseCase(mockRoomRepository);

    // Initialize test data in setUp for reuse
    testParams =  GetRoomsParams(
      search: 'Room 1',
      orderBy: 'name',
      page: 1,
      size: 10,
    );

    testRoom =  Room(
      id: '1',
      name: 'Room 1',
      status: 'Active',
      size: 25,
      furnitureIncluded: true,
      createdAt: '2025-02-18',
      updatedAt: '2025-02-18',
      squareMeters: '25',
      houseId: 'house_1',
      roomTypeId: 'type_1',
      code: 'R1',
    );

    testBaseResponse = BaseResponse<Room>(
        items: [testRoom],
        total: 1,
        page: 1,
        size: 1,
        totalPages: 1
    );
  });

  group('GetRoomsUseCase', () {
    test('should return Right(BaseResponse) when repository call is successful', () async {
      // Arrange
      when(mockRoomRepository.getRooms(
        testParams.search,
        testParams.orderBy,
        testParams.page,
        testParams.size,
      )).thenAnswer((_) async => testBaseResponse);

      // Act
      final result = await getRoomsUseCase.call(testParams);

      // Assert
      expect(result, isA<Right<Failure, BaseResponse<Room>>>());
      expect(result, Right(testBaseResponse));

      final rightValue = (result as Right<Failure, BaseResponse<Room>>).value;
      expect(rightValue.items.first.id, testRoom.id);
      expect(rightValue.items.first.name, testRoom.name);

      verify(mockRoomRepository.getRooms(
        testParams.search,
        testParams.orderBy,
        testParams.page,
        testParams.size,
      )).called(1);
      verifyNoMoreInteractions(mockRoomRepository);
    });

    test('should return Left(ServerFailure) when repository throws exception', () async {
      // Arrange
      const errorMessage = 'Failed to load rooms';
      when(mockRoomRepository.getRooms(
        testParams.search,
        testParams.orderBy,
        testParams.page,
        testParams.size,
      )).thenThrow(Exception(errorMessage));  // Throw exception with message

      // Act
      final result = await getRoomsUseCase.call(testParams);

      // Assert
      expect(result.isLeft(), true);
      final leftValue = result.fold(
            (failure) => failure,
            (response) => null,
      );

      expect(leftValue, isA<ServerFailure>());
      expect((leftValue as ServerFailure).message.toString().replaceFirst('Exception: ', ''), errorMessage); // Strip the prefix

      verify(mockRoomRepository.getRooms(
        testParams.search,
        testParams.orderBy,
        testParams.page,
        testParams.size,
      )).called(1);
      verifyNoMoreInteractions(mockRoomRepository);
    });

    test('should handle null parameters', () async {
      // Arrange
      when(mockRoomRepository.getRooms(
        null,
        null,
        null,
        null,
      )).thenAnswer((_) async => testBaseResponse);

      // Act
      final result = await getRoomsUseCase.call(GetRoomsParams());

      // Assert
      expect(result, isA<Right<Failure, BaseResponse<Room>>>());
      expect(result, Right(testBaseResponse));

      verify(mockRoomRepository.getRooms(
        null,
        null,
        null,
        null,
      )).called(1);
      verifyNoMoreInteractions(mockRoomRepository);
    });
  });
}