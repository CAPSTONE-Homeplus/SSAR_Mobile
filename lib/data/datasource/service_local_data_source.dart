import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocalDataSource {
  static const _selectedServiceIdsKey = 'selectedServiceIdsKey';
  final SharedPreferences sharedPreferences;

  ServiceLocalDataSource({required this.sharedPreferences});

  Future<void> saveSelectedServiceIds(List<String> ids) async {
    await sharedPreferences.setStringList(_selectedServiceIdsKey, ids);
  }

  Future<List<String>?> getSelectedServiceIds() {
    return Future.value(
        sharedPreferences.getStringList(_selectedServiceIdsKey));
  }

  Future<void> clearSelectedServiceIds() async {
    await sharedPreferences.remove(_selectedServiceIdsKey);
  }
}
