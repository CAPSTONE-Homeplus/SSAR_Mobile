import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/datasource/auth_local_datasource.dart';
import 'package:home_clean/data/datasource/user_local_datasource.dart';
import 'package:home_clean/data/models/user/user_model.dart';
import 'package:home_clean/domain/entities/user/user.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';

import '../../../core/api_constant.dart';
import '../../../core/exception_handler.dart';
import '../../domain/entities/user/create_user.dart';
import '../mappers/user/user_mapper.dart';
import '../models/authen/authen_model.dart';
import '../models/authen/login_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource authLocalDataSource;
  final UserLocalDatasource userLocalDatasource;

  AuthRepositoryImpl({
    required this.authLocalDataSource,
    required this.userLocalDatasource,
  });

  @override
  Future<bool> login(LoginModel loginModel) async {
    try {
      final response = await vinWalletRequest.post(
        '${ApiConstant.AUTH}/login',
        data: {
          'username': loginModel.username,
          'password': loginModel.password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        AuthenModel authData = AuthenModel(
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken'],
          userId: response.data['userId'],
          fullName: response.data['fullName'],
          status: response.data['status'],
          role: response.data['role'],
        );
        await authLocalDataSource.saveAuth(authData);

        final userResponse = await vinWalletRequest.get(
          '${ApiConstant.USERS}/${authData.userId}',
        );
        if (userResponse.statusCode == 200 && userResponse.data != null) {
          await userLocalDatasource.saveUser(userResponse.data);
        }

        return true;
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<void> clearUserFromLocal() async {
    try {
      await authLocalDataSource.clearAuth();
      await userLocalDatasource.clearUser();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }


  @override
  Future<void> saveUserFromLocal(User user) async {
    UserModel userModel = UserMapper.toModel(user);
    await userLocalDatasource.saveUser(userModel);
  }

  @override
  Future<User> createAccount(CreateUser createUser) async {
    try {
      final response = await vinWalletRequest.post(
        ApiConstant.USERS,
        data: {
          "fullName": createUser.fullName,
          "username": createUser.username,
          "password": createUser.password,
          "roomCode": createUser.roomCode,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        await userLocalDatasource.saveUser(response.data);
        User user = UserMapper.toEntity(response.data);
        return user;
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<User> getUserFromLocal() async{
    try {
      UserModel? userModel = await userLocalDatasource.getUser();
      User user = UserMapper.toEntity(userModel!);
      return user;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
