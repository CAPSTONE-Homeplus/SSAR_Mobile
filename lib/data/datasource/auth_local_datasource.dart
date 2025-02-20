import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/authen/authen_model.dart';

class AuthLocalDataSource {
  static const String _authKey = 'cached_auth';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Lưu AuthenModel một cách an toàn
  Future<void> saveAuth(AuthenModel auth) async {
    String authJson = jsonEncode(auth.toJson());
    await _secureStorage.write(key: _authKey, value: authJson);
  }

  // Lấy AuthenModel từ bộ nhớ bảo mật
  Future<AuthenModel?> getAuth() async {
    String? authJson = await _secureStorage.read(key: _authKey);
    if (authJson == null) return null;
    return AuthenModel.fromJson(jsonDecode(authJson));
  }

  // Xóa AuthenModel khỏi bộ nhớ bảo mật
  Future<void> clearAuth() async {
    await _secureStorage.delete(key: _authKey);
  }

  Future<String?> getRefreshTokenFromStorage() async {
    String? authJson = await _secureStorage.read(key: _authKey);
    if (authJson == null) return null;
    try {
      Map<String, dynamic> authData = jsonDecode(authJson);
      return authData['refreshToken'];
    } catch (e) {
      print("Lỗi khi đọc refreshToken: $e");
      return null;
    }
  }

  Future<void> saveTokensToStorage(String token, String refreshToken) async {
    String? authJson = await _secureStorage.read(key: _authKey);
    if (authJson == null) return;
    try {
      Map<String, dynamic> authData = jsonDecode(authJson);
      authData['accessToken'] = token;
      authData['refreshToken'] = refreshToken;
      await _secureStorage.write(key: _authKey, value: jsonEncode(authData));
    } catch (e) {
      print("Lỗi khi lưu token: $e");
    }
  }

}
