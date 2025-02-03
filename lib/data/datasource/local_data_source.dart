import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const String _selectedTimeSlotIdsKey = 'selected_time_slot_ids';
  static const String _selectedServiceIdsKey = 'selected_service_ids';
  static const String _selectedOptionIdsKey = 'selected_option_ids';
  static const String _selectedExtraServicesIdsKey =
      'selected_extra_services_ids';

  // time slots

  Future<void> saveSelectedTimeSlotIds(List<String> ids) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedTimeSlotIdsKey, ids);
  }

  Future<List<String>?> getSelectedTimeSlotIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_selectedTimeSlotIdsKey);
  }

  Future<void> clearSelectedTimeSlotIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedTimeSlotIdsKey);
  }

  // clear all

  Future<void> clearAllSelectedIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedTimeSlotIdsKey);
    await prefs.remove(_selectedServiceIdsKey);
    await prefs.remove(_selectedOptionIdsKey);
    await prefs.remove(_selectedExtraServicesIdsKey);
  }
}
