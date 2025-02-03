import 'package:dio/dio.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/repositories/auth/authentication_repository.dart';

import '../../models/authen/authen_model.dart';
import '../../models/authen/create_authen_model.dart';
import '../../models/authen/login_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<AuthenModel?> loginWithGmail(
      CreateAuthenModel createAuthenModel) async {
    try {
      final response = await request.post(
        '/api/v1/account/create',
        data: createAuthenModel.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return AuthenModel.fromJson(response.data);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.statusCode} - ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthenModel?> registerAccount(
      CreateAuthenModel createAuthenModel) async {
    try {
      final response = await request.post(
        '/api/v1/account/create',
        data: createAuthenModel.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return AuthenModel.fromJson(response.data);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} - ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> login(LoginModel loginModel) async {
    try {
      final response = await request.post(
        '/auth/login',
        data: loginModel.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }
}
