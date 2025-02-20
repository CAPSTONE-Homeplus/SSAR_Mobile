import 'package:flutter_test/flutter_test.dart';
import 'package:home_clean/domain/entities/user/create_user.dart';
import 'package:home_clean/domain/entities/user/user.dart';
import 'package:home_clean/domain/usecases/auth/login_usecase.dart';
import 'package:home_clean/domain/usecases/auth/user_register_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:home_clean/data/models/authen/login_model.dart';

import '../../../helper/test_helper.mocks.dart';

void main() {
  late MockAuthRepository repository;
  late LoginUseCase loginUseCase;
  late UserRegisterUseCase registerUseCase;

  setUp(() {
    repository = MockAuthRepository();
    loginUseCase = LoginUseCase(repository);
    registerUseCase = UserRegisterUseCase(repository);
  });

  group('Login Tests', () {
    test('login should return true when successful', () async {
      final loginModel = LoginModel(username: 'testuser', password: 'testpass');
      when(repository.login(loginModel)).thenAnswer((_) async => true);

      final result = await loginUseCase.call(loginModel);

      expect(result, true);
      expect(result, true);
      verify(repository.login(loginModel)).called(1);
    });

    test('login should return false when failed', () async {
      final loginModel = LoginModel(username: 'wronguser', password: 'wrongpass');
      when(repository.login(loginModel)).thenAnswer((_) async => false);

      final result = await loginUseCase.call(loginModel);

      expect(result, false);
      verify(repository.login(loginModel)).called(1);
    });

    test('methods should throw exception when error occurs', () async {
      final loginModel = LoginModel(username: 'test', password: 'test');

      when(repository.login(loginModel)).thenThrow(Exception('Login error'));

      expect(() async => await loginUseCase.call(loginModel), throwsA(isA<Exception>()));
      verify(repository.login(loginModel)).called(1);
    });
  });

  group('Register Tests', () {
    test('createAccount should return User object when successful', () async {
      final createUser = CreateUser(
        username: 'testuser',
        password: 'testpass',
        fullName: 'Test User',
        roomCode: 'room_code',
      );
      final expectedUser = User(
        id: 'user_id',
        fullName: 'Test User',
        status: 'active',
        roomId: 'room_id',
        extraField: 'extra',
        createdAt: '2021-09-01',
        updatedAt: '2021-09-01',
        username: 'testuser',
        role: 'Member',
      );

      when(repository.createAccount(createUser)).thenAnswer((_) async => expectedUser);

      final result = await registerUseCase.call(createUser);

      expect(result, isA<User>());
      expect(result.id, expectedUser.id);
      expect(result.fullName, expectedUser.fullName);
      expect(result.username, expectedUser.username);
      expect(result.role, expectedUser.role);
      expect(result.status, expectedUser.status);
      expect(result.roomId, expectedUser.roomId);
      expect(result.extraField, expectedUser.extraField);
      expect(result.createdAt, expectedUser.createdAt);
      expect(result.updatedAt, expectedUser.updatedAt);

      verify(repository.createAccount(createUser)).called(1);
    });

    test('createAccount should throw exception when there is an error', () async {
      final createUser = CreateUser(
        username: 'testuser',
        password: 'testpass',
        fullName: 'Test User',
        roomCode: 'room_code',
      );
      when(repository.createAccount(createUser)).thenThrow(Exception('Error creating account'));

      expect(() async => await registerUseCase.call(createUser), throwsA(isA<Exception>()));
      verify(repository.createAccount(createUser)).called(1);
    });

    test('createAccount should throw exception when username is existed', () async {
      final createUser = CreateUser(
        username: 'testuser',
        password: 'testpass',
        fullName: 'Test User',
        roomCode: 'room_code',
      );
      when(repository.createAccount(createUser)).thenThrow(Exception('Username is existed'));

      expect(() async => await registerUseCase.call(createUser), throwsA(isA<Exception>()));
      verify(repository.createAccount(createUser)).called(1);
    });

    test('createAccount should throw exception when account creation fails', () async {
      final createUser = CreateUser(
        username: 'testuser',
        password: 'testpass',
        fullName: 'Test User',
        roomCode: 'room_code',
      );
      when(repository.createAccount(createUser)).thenThrow(Exception('Account creation failed'));

      expect(() async => await registerUseCase.call(createUser), throwsA(isA<Exception>()));
      verify(repository.createAccount(createUser)).called(1);
    });

    test('createAccount should throw exception when username or password is empty', () async {
      final createUser = CreateUser(
        username: 'testuser',
        password: 'testpass',
        fullName: 'Test User',
        roomCode: 'room_code',
      );
      when(repository.createAccount(createUser)).thenThrow(Exception('Invalid username or password'));

      expect(() async => await registerUseCase.call(createUser), throwsA(isA<Exception>()));
      verify(repository.createAccount(createUser)).called(1);
    });
  });
}
