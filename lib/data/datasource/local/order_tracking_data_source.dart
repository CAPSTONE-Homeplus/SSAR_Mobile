import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/order/order_tracking.dart';

class OrderTrackingLocalDataSource {
  static const String _storageKey = 'order_tracking_list';

  /// Lưu danh sách order tracking vào SharedPreferences
  Future<void> saveOrderTracking(OrderTracking orderTracking) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existingData = prefs.getStringList(_storageKey) ?? [];

      // Chuyển đổi danh sách JSON thành danh sách Map
      final List<Map<String, dynamic>> orderList = existingData
          .map((orderJson) => json.decode(orderJson) as Map<String, dynamic>)
          .toList();

      // Kiểm tra xem orderId đã tồn tại chưa, nếu có thì cập nhật
      final index = orderList.indexWhere((item) => item['orderId'] == orderTracking.orderId);
      if (index != -1) {
        orderList[index] = orderTracking.toJson();
      } else {
        orderList.add(orderTracking.toJson());
      }

      // Lưu lại vào SharedPreferences
      await prefs.setStringList(_storageKey, orderList.map(json.encode).toList());

      print('💾 Đã lưu thông tin theo dõi đơn hàng: ${orderTracking.orderId}');
    } catch (e) {
      print('❌ Lỗi khi lưu đơn hàng: $e');
    }
  }

  /// Lấy thông tin một đơn hàng theo ID
  Future<OrderTracking?> getOrderTracking(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? storedData = prefs.getStringList(_storageKey);

      if (storedData == null) return null;

      final orderList = storedData
          .map((jsonData) => json.decode(jsonData) as Map<String, dynamic>)
          .toList();

      final orderData = orderList.firstWhere(
            (order) => order['orderId'] == orderId,
        orElse: () => {},
      );

      if (orderData.isEmpty) return null;

      return OrderTracking.fromJson(orderData);
    } catch (e) {
      print('❌ Lỗi khi lấy đơn hàng: $e');
      return null;
    }
  }

  /// Lấy toàn bộ danh sách đơn hàng đã lưu
  Future<List<OrderTracking>> getAllOrderTrackings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? storedData = prefs.getStringList(_storageKey);

      if (storedData == null) return [];

      return storedData
          .map((jsonData) => OrderTracking.fromJson(json.decode(jsonData)))
          .toList();
    } catch (e) {
      print('❌ Lỗi khi lấy danh sách đơn hàng: $e');
      return [];
    }
  }

  /// Xóa một đơn hàng theo ID
  Future<void> removeOrderTracking(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? storedData = prefs.getStringList(_storageKey);

      if (storedData == null) return;

      final orderList = storedData
          .map((jsonData) => json.decode(jsonData) as Map<String, dynamic>)
          .toList();

      // Lọc bỏ đơn hàng có orderId cần xóa
      orderList.removeWhere((order) => order['orderId'] == orderId);

      // Lưu lại danh sách mới
      await prefs.setStringList(_storageKey, orderList.map(json.encode).toList());

      print('🗑️ Đã xóa thông tin theo dõi đơn hàng: $orderId');
    } catch (e) {
      print('❌ Lỗi khi xóa đơn hàng: $e');
    }
  }

  /// Xóa toàn bộ danh sách đơn hàng đã lưu
  Future<void> clearAllOrderTrackings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      print('🧹 Đã xóa toàn bộ thông tin theo dõi đơn hàng');
    } catch (e) {
      print('❌ Lỗi khi xóa toàn bộ đơn hàng: $e');
    }
  }
}
