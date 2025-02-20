import 'package:dio/dio.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/datasource/authen_local_datasource.dart';
import 'package:home_clean/data/mappers/user/create_user_mapper.dart';
import 'package:home_clean/domain/entities/user/user.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';

import '../../../core/api_constant.dart';
import '../../../core/exception_handler.dart';
import '../../../domain/entities/auth/authen.dart';
import '../../domain/entities/user/create_user.dart';
import '../mappers/user/user_mapper.dart';
import '../models/authen/authen_model.dart';
import '../models/authen/login_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthenticationLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});
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
        Future.delayed(Duration(seconds: 2));
        saveUserFromLocal(AuthenModel(
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken'],
          userId: response.data['userId'],
          fullName: response.data['fullName'],
          status: response.data['status'],
          role: response.data['role'],
        ));
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
    localDataSource.clearAuthenticationData();
  }

  @override
  Future<Authen> getUserFromLocal() async {
    try {
      AuthenModel authenModel = await localDataSource.getUser();
      return Authen(
        accessToken: authenModel.accessToken ?? '',
        refreshToken: authenModel.refreshToken ?? '',
        userId: authenModel.userId ?? '',
        fullName: authenModel.fullName ?? '',
        status: authenModel.status ?? '',
        role: authenModel.role ?? '',
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }


  @override
  Future<void> saveUserFromLocal(AuthenModel authenModel) async {
    await localDataSource.saveUser(authenModel);
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
}
