import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/activity_status/activity_status_model.dart';

class ActivityStatusLocalDataSource {
  static const String ACTIVITY_STATUS_KEY = 'ACTIVITY_STATUS';

  ActivityStatusLocalDataSource();

  /// Lấy danh sách trạng thái hoạt động từ local storage
  Future<List<ActivityStatusModel>> getActivityStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? activityStatusJson = prefs.getString(ACTIVITY_STATUS_KEY);

      if (activityStatusJson == null || activityStatusJson.isEmpty) {
        return [];
      }

      List<dynamic> jsonList = jsonDecode(activityStatusJson);
      return jsonList.map((json) => ActivityStatusModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Lỗi đọc ActivityStatus từ SharedPreferences: $e');
      return [];
    }
  }


  /// Lưu danh sách trạng thái hoạt động vào local storage
  Future<void> saveActivityStatuses(List<ActivityStatusModel> activityStatusList) async {
    try {
      if (activityStatusList.isEmpty) {
        await clearActivityStatus();
        return;
      }

      final String jsonData = jsonEncode(
        activityStatusList.map((status) => status.toJson()).toList(),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ACTIVITY_STATUS_KEY, jsonData);
    } catch (e) {
      print('❌ Lỗi khi lưu danh sách trạng thái hoạt động: $e');
    }
  }


  Future<void> addActivityStatuses(List<ActivityStatusModel> newStatuses) async {
    try {
      List<ActivityStatusModel> currentList = await getActivityStatus() ?? [];

      for (var newStatus in newStatuses) {
        int index = currentList.indexWhere((s) => s.activityId == newStatus.activityId);
        if (index != -1) {
          currentList[index] = newStatus;
        } else {
          currentList.add(newStatus);
        }
      }

      await saveActivityStatuses(currentList);
    } catch (e) {
      print('❌ Lỗi khi lưu trạng thái mới: $e');
    }
  }


  /// Xóa toàn bộ dữ liệu trạng thái hoạt động
  Future<void> clearActivityStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACTIVITY_STATUS_KEY);
  }
}
