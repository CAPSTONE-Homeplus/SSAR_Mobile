import 'package:shared_preferences/shared_preferences.dart';

class ExtraServiceLocalDataSource {
  static const String _selectedExtraServiceIdsKey = 'selectedExtraServiceIds';
  final SharedPreferences sharedPreferences;

  ExtraServiceLocalDataSource({required this.sharedPreferences});

  Future<void> saveSelectedExtraServiceIds(List<String> ids) async {
    await sharedPreferences.setStringList(_selectedExtraServiceIdsKey, ids);
  }

  Future<List<String>?> getSelectedExtraServiceIds() {
    return Future.value(
        sharedPreferences.getStringList(_selectedExtraServiceIdsKey));
  }

  Future<void> clearSelectedExtraServiceIds() async {
    await sharedPreferences.remove(_selectedExtraServiceIdsKey);
  }
}
