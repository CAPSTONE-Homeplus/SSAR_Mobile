import 'package:shared_preferences/shared_preferences.dart';

class OptionLocalDataSource {
  static const String _selectedOptionIdsKey = 'selectedOptionIdsKey';
  final SharedPreferences sharedPreferences;

  OptionLocalDataSource({required this.sharedPreferences});

  Future<void> saveSelectedOptionIds(List<String> ids) async {
    await sharedPreferences.setStringList(_selectedOptionIdsKey, ids);
  }

  Future<List<String>?> getSelectedOptionIds() {
    return Future.value(sharedPreferences.getStringList(_selectedOptionIdsKey));
  }

  Future<void> clearSelectedOptionIds() async {
    await sharedPreferences.remove(_selectedOptionIdsKey);
  }
}
