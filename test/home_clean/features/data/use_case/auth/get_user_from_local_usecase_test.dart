import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/exception/failure.dart';
import 'package:home_clean/domain/entities/user/user.dart';
import 'package:home_clean/domain/use_cases/auth/get_user_from_local_usecase.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetUserFromLocalUseCase getUserFromLocalUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getUserFromLocalUseCase = GetUserFromLocalUseCase(mockAuthRepository);
  });

  final expectedUser = User(
    id: 'user_id',
    fullName: 'Test User',
    status: 'active',
    houseId: null,
    extraField: null,
    createdAt: '2021-09-01',
    updatedAt: '2021-09-01',
    username: 'testuser',
    role: 'Member',
  );

  group('GetUserFromLocalUseCase Tests', () {
    test('should return User when local data retrieval is successful', () async {
      // Arrange
      when(mockAuthRepository.getUserFromLocal()).thenAnswer((_) async => expectedUser);

      // Act
      final result = await getUserFromLocalUseCase();

      // Assert
      expect(result, isA<Right<Failure, User>>());
      expect(result.isRight(), true);
      expect((result as Right).value, expectedUser);
      verify(mockAuthRepository.getUserFromLocal()).called(1);
    });

    test('should return CacheFailure when an exception is thrown', () async {
      // Arrange
      when(mockAuthRepository.getUserFromLocal()).thenThrow(Exception('Cache error'));

      // Act
      final result = await getUserFromLocalUseCase();

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
            (failure) {
          expect(failure, isA<CacheFailure>());
          expect((failure as CacheFailure).message, 'Error when getting user from local');
        },
            (_) => fail('Expected Left<CacheFailure>, but got Right'),
      );
      verify(mockAuthRepository.getUserFromLocal()).called(1);
    });
  });
}
