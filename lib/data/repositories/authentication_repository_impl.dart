import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/datasource/local/auth_local_datasource.dart';
import 'package:home_clean/data/datasource/local/user_local_datasource.dart';
import 'package:home_clean/data/mappers/auth/auth_mapper.dart';
import 'package:home_clean/data/models/user/user_model.dart';
import 'package:home_clean/domain/entities/user/user.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';

import '../../core/constant/constants.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/constant/api_constant.dart';
import '../../domain/entities/auth/auth.dart';
import '../../domain/entities/user/create_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../mappers/user/user_mapper.dart';
import '../models/auth/login_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource authLocalDataSource;
  final UserLocalDatasource userLocalDatasource;
  final UserRepository userRepository;

  AuthRepositoryImpl({
    required this.authLocalDataSource,
    required this.userLocalDatasource,
    required this.userRepository,
  });

  @override
  Future<bool> login(LoginModel loginModel) async {
    try {
      authLocalDataSource.clearAuth();
      userLocalDatasource.clearUser();

      final response = await vinWalletRequest.post(
        '${ApiConstant.auth}/login',
        data: {
          'username': loginModel.username,
          'password': loginModel.password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        await authLocalDataSource.saveAuth(response.data);
        final accessToken =
            await authLocalDataSource.getAccessTokenFromStorage();
        final rfToken = await authLocalDataSource.getRefreshTokenFromStorage();
        vinWalletRequest.options.headers['Authorization'] =
            'Bearer $accessToken';
        homeCleanRequest.options.headers['Authorization'] =
            'Bearer $accessToken';
        vinLaundryRequest.options.headers['Authorization'] =
            'Bearer $accessToken';
        final user = await userRepository.getUser(response.data['userId']);
        await userLocalDatasource
            .saveUserModel(UserMapper.toModelFromEntity(user));
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
  Future<User> createAccount(CreateUser createUser) async {
    try {
      final response = await vinWalletRequest.post(
        ApiConstant.users,
        data: {
          "fullName": createUser.fullName,
          "username": createUser.username,
          "password": createUser.password,
          "buildingCode": createUser.buildingCode,
          "houseCode": createUser.houseCode,
          "phoneNumber": "${createUser.phoneNumber}",
          "email": createUser.email,
          "citizenCode": createUser.citizenCode,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        User user = UserMapper.toEntity(UserMapper.toModel(response.data));
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
      print("Lỗi exception: $e");
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<User> getUserFromLocal() async {
    try {
      UserModel? userModel =
          UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      User user = UserMapper.toEntity(userModel);
      return user;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  Future<String> _getUserId() async {
    final authModel = AuthMapper.toModel(
      await authLocalDataSource.getAuth() ?? {},
    );
    final userId = authModel.userId;

    if (userId == null || userId.isEmpty) {
      throw Exception('User ID is empty');
    }

    return userId;
  }

  @override
  Future<Auth> refreshToken() async {
    try {
      final user =
          UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      final auth =
          AuthMapper.toModel(await authLocalDataSource.getAuth() ?? {});
      final response = await vinWalletRequest.post(
        '${ApiConstant.auth}/refresh-token',
        data: {
          "userId": user.id,
          "refreshToken": auth.refreshToken,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        await authLocalDataSource.saveAuth(response.data);
        final accessToken =
            await authLocalDataSource.getAccessTokenFromStorage();
        vinWalletRequest.options.headers['Authorization'] =
            'Bearer $accessToken';
        homeCleanRequest.options.headers['Authorization'] =
            'Bearer $accessToken';
        userRepository.getUser(response.data['userId']);
        return AuthMapper.toEntity(response.data);
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
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final response = await vinWalletRequest.post(
        '${ApiConstant.users}/reset-password',
        data: {
          'email': email,
          'newPassword': newPassword,
          'confirmPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
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
  Future<bool> sendResetEmail(String email) async {
    try {
      final response = await vinWalletRequest.post(
        '${ApiConstant.users}/forgot-password',
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
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
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await vinWalletRequest.post(
        '${ApiConstant.users}/verify-code',
        data: {
          'email': email,
          'verificationCode': otp,
        },
      );

      if (response.statusCode == 200) {
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
  Future<bool> isValidToken() async {
    try {
      final user =
      UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      final response = await homeCleanRequest.get(
        '${ApiConstant.orders}/by-user',
        queryParameters: {
          'userId': user.id,
          'search': '',
          'orderBy': '',
          'page': Constant.defaultPage,
          'size': Constant.defaultSize
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        return false;
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
