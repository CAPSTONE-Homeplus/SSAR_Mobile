import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationLocalDataSource {
  static const String _selectedUserNameKey = 'selectedUserNameKey';
  final SharedPreferences sharedPreferences;

  AuthenticationLocalDataSource({required this.sharedPreferences});

  Future<void> saveSelectedUserName(String userName) async {
    await sharedPreferences.setString(_selectedUserNameKey, userName);
  }

  Future<String?> getSelectedUserName() {
    return Future.value(sharedPreferences.getString(_selectedUserNameKey));
  }

  Future<void> clearSelectedUserName() async {
    await sharedPreferences.remove(_selectedUserNameKey);
  }

}
