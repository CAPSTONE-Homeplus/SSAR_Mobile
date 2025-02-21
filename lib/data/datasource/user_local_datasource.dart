import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLocalDatasource {

  final String _userKey = dotenv.env['USER_KEY'] ?? 'default_user_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // 🟢 Lưu dữ liệu dưới dạng Map<String, dynamic>
  Future<void> saveUser(Map<String, dynamic> userData) async {
    String userJson = jsonEncode(userData);
    await _secureStorage.write(key: _userKey, value: userJson);
  }

  // 🟢 Lấy dữ liệu từ bộ nhớ dưới dạng Map<String, dynamic>
  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await _secureStorage.read(key: _userKey);
    if (userJson == null) return null;
    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  // 🟢 Xóa dữ liệu khỏi bộ nhớ bảo mật
  Future<void> clearUser() async {
    await _secureStorage.delete(key: _userKey);
  }
}
