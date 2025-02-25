import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/core/exception/failure.dart';
import 'package:home_clean/domain/entities/user/create_user.dart';
import 'package:home_clean/domain/entities/user/user.dart';
import 'package:home_clean/domain/use_cases/auth/user_register_usecase.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late UserRegisterUseCase userRegisterUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    userRegisterUseCase = UserRegisterUseCase(mockAuthRepository);
  });

  final createUser = CreateUser(
    username: 'testuser',
    password: 'testpass',
    fullName: 'Test User',
    buildingCode: 'buildingCode',
    houseCode: 'houseCode',
  );

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

  group('UserRegisterUseCase Tests', () {
    test('should return User when registration is successful', () async {
      // Arrange
      when(mockAuthRepository.createAccount(createUser))
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await userRegisterUseCase.execute(createUser);

      // Assert
      expect(result, isA<Right<Failure, User>>());
      expect(result.isRight(), true);
      expect((result as Right).value, expectedUser);
      verify(mockAuthRepository.createAccount(createUser)).called(1);
    });

    test('should return ApiFailure when ApiException is thrown', () async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(mockAuthRepository.createAccount(createUser))
          .thenThrow(ApiException(description: errorMessage, code: 500, message: 'Internal Server', timestamp: '2021-10-10'));

      // Act
      final result = await userRegisterUseCase.execute(createUser);

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
            (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).message, errorMessage);
        },
            (_) => fail('Expected Left<ApiFailure>, but got Right'),
      );
      verify(mockAuthRepository.createAccount(createUser)).called(1);
    });

    test('should return ServerFailure when general Exception is thrown', () async {
      // Arrange
      when(mockAuthRepository.createAccount(createUser))
          .thenThrow(Exception('Something went wrong'));

      // Act
      final result = await userRegisterUseCase.execute(createUser);

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
            (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, contains('Lỗi hệ thống'));
        },
            (_) => fail('Expected Left<ServerFailure>, but got Right'),
      );
      verify(mockAuthRepository.createAccount(createUser)).called(1);
    });
  });
}
