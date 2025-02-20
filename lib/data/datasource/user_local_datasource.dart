import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user/user_model.dart';

class UserLocalDatasource {
  static const String _userKey = 'cached_user';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Lưu UserModel vào bộ nhớ bảo mật
  Future<void> saveUser(UserModel user) async {
    String userJson = jsonEncode(user.toJson());
    await _secureStorage.write(key: _userKey, value: userJson);
  }

  // Lấy UserModel từ bộ nhớ bảo mật
  Future<UserModel?> getUser() async {
    String? userJson = await _secureStorage.read(key: _userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  // Xóa UserModel khỏi bộ nhớ bảo mật
  Future<void> clearUser() async {
    await _secureStorage.delete(key: _userKey);
  }
}
