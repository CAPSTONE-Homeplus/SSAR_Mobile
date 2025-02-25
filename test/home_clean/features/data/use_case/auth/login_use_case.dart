import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/core/exception/failure.dart';
import 'package:home_clean/data/models/auth/login_model.dart';
import 'package:home_clean/domain/use_cases/auth/login_usecase.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  final testLoginModel = LoginModel(
    username: 'testuser',
    password: 'password123',
  );

  group('LoginUseCase', () {
    test('should return true when login is successful', () async {
      // Arrange
      when(mockAuthRepository.login(testLoginModel))
          .thenAnswer((_) async => true);

      // Act
      final result = await loginUseCase.call(testLoginModel);

      // Assert
      expect(result, isA<Right<Failure, bool>>());
      expect(result.isRight(), true);
      expect((result as Right).value, true);
      verify(mockAuthRepository.login(testLoginModel)).called(1);
    });

    test('should return ApiFailure when ApiException is thrown', () async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(mockAuthRepository.login(testLoginModel))
          .thenThrow(ApiException(description: errorMessage, code: 401, message: 'Unauthorized', timestamp: '2021-10-10'));

      // Act
      final result = await loginUseCase.call(testLoginModel);

      // Assert
      result.fold(
            (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).message, errorMessage);
        },
            (_) => fail('Expected Left<ApiFailure>, but got Right'),
      );
      verify(mockAuthRepository.login(testLoginModel)).called(1);
    });

    test('should return ApiFailure with default message when ApiException has null description', () async {
      // Arrange
      when(mockAuthRepository.login(testLoginModel))
          .thenThrow(ApiException(description: null, code: 500, message: 'Internal server error', timestamp: '2021-10-10'));

      // Act
      final result = await loginUseCase.call(testLoginModel);

      // Assert
      result.fold(
            (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).message, 'Lỗi API không xác định!');
        },
            (_) => fail('Expected Left<ApiFailure>, but got Right'),
      );
      verify(mockAuthRepository.login(testLoginModel)).called(1);
    });

    test('should return ServerFailure when a general exception is thrown', () async {
      // Arrange
      final exception = Exception('Network error');
      when(mockAuthRepository.login(testLoginModel))
          .thenThrow(exception);

      // Act
      final result = await loginUseCase.call(testLoginModel);

      // Assert
      result.fold(
            (failure) {
          expect(failure, isA<ServerFailure>());
        },
            (_) => fail('Expected Left<ServerFailure>, but got Right'),
      );
      verify(mockAuthRepository.login(testLoginModel)).called(1);
    });
  });
}
