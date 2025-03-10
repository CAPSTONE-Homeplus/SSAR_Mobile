import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthLocalDataSource {
  final String _authKey = dotenv.env['AUTH_KEY'] ?? 'default_auth_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveAuth(Map<String, dynamic> authData) async {
    String authJson = jsonEncode(authData);
    await _secureStorage.write(key: _authKey, value: authJson);
  }

  Future<Map<String, dynamic>?> getAuth() async {
    String? authJson = await _secureStorage.read(key: _authKey);
    if (authJson == null) return null;
    return jsonDecode(authJson) as Map<String, dynamic>;
  }

  Future<void> clearAuth() async {
    await _secureStorage.delete(key: _authKey);
  }

  Future<String?> getAccessTokenFromStorage() async {
    String? authJson = await _secureStorage.read(key: _authKey);
    if (authJson == null) return null;

    try {
      final Map<String, dynamic> authData = jsonDecode(authJson);
      return authData['accessToken'] as String?;
    } catch (e) {
      print("Lỗi khi đọc accessToken: $e");
      return null;
    }
  }

  Future<String?> getRefreshTokenFromStorage() async {
    String? authJson = await _secureStorage.read(key: _authKey);
    if (authJson == null) return null;

    try {
      final Map<String, dynamic> authData = jsonDecode(authJson);
      return authData['refreshToken'] as String?;
    } catch (e) {
      print("Lỗi khi đọc refreshToken: $e");
      return null;
    }
  }


  Future<void> saveTokensToStorage(String token, String refreshToken) async {
    Map<String, dynamic>? authData = await getAuth();
    if (authData == null) return;

    authData['accessToken'] = token;
    authData['refreshToken'] = refreshToken;

    await saveAuth(authData);
  }
}
