import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/authen/authen_model.dart';

class AuthenticationLocalDataSource {
  static const String _selectedUserNameKey = 'selectedUserNameKey';
  static const String _selectedUserKey = 'selectedUserKey';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage storage;

  AuthenticationLocalDataSource({
    required this.sharedPreferences,
    required this.storage,
  });

  /// Lưu Access Token (dữ liệu nhạy cảm)
  Future<void> saveAccessToken(String token) async {
    await storage.write(key: _accessTokenKey, value: token);
  }

  /// Lấy Access Token
  Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  /// Lưu Refresh Token
  Future<void> saveRefreshToken(String refreshToken) async {
    await storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// Lấy Refresh Token
  Future<String?> getRefreshToken() async {
    return await storage.read(key: _refreshTokenKey);
  }

  /// Lưu thông tin user dưới dạng JSON
  Future<void> saveUser(AuthenModel authenModel) async {
    String jsonString = json.encode(authenModel.toJson());
    await storage.write(key: _selectedUserKey, value: jsonString);
  }

  /// Lấy user từ storage và convert lại thành AuthenModel
  Future<AuthenModel> getUser() async {
    final jsonString = await storage.read(key: _selectedUserKey);
    if (jsonString != null) {
      return AuthenModel.fromJson(jsonString);
    }
    throw Exception('Không tìm thấy user');
  }

  /// Xóa user khỏi storage
  Future<void> clearUser() async {
    await storage.delete(key: _selectedUserKey);
  }

  /// Xóa tất cả thông tin xác thực
  Future<void> clearAuthenticationData() async {
    await sharedPreferences.remove(_selectedUserNameKey);
    await storage.delete(key: _accessTokenKey);
    await storage.delete(key: _refreshTokenKey);
  }
}

