import 'package:dio/dio.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/datasource/authen_local_datasource.dart';
import 'package:home_clean/data/repositories/auth/authentication_repository.dart';

import '../../../core/api_constant.dart';
import '../../../core/exception_handler.dart';
import '../../models/authen/authen_model.dart';
import '../../models/authen/create_authen_model.dart';
import '../../models/authen/login_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationLocalDataSource localDataSource;

  AuthenticationRepositoryImpl({required this.localDataSource});
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
        return true;
      } else {
        throw ApiException(
          errorCode: response.statusCode,
          errorMessage: response.statusMessage ?? 'Lỗi không xác định',
          errorStatus: response.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<void> clearUser() async {
    localDataSource.clearSelectedUserName();
  }

  @override
  Future<String?> getUserName() async {
    return localDataSource.getSelectedUserName();
  }

  @override
  Future<void> saveUserName(String userName) async {
     localDataSource.saveSelectedUserName(userName);
  }

}
