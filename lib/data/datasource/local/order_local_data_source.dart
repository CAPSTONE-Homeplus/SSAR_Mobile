import 'dart:convert';
import 'package:home_clean/data/models/order/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class OrderLocalDataSource {
//   static const String _orderKey = 'saved_orders';
//
//   Future<void> saveOrder(OrderModel order) async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> savedOrders = prefs.getStringList(_orderKey) ?? [];
//
//     savedOrders.add(jsonEncode(order.toJson()));
//
//     await prefs.setStringList(_orderKey, savedOrders);
//   }
//
//   Future<List<OrderModel>> getSavedOrders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> savedOrders = prefs.getStringList(_orderKey) ?? [];
//
//     return savedOrders.map((order) => OrderModel.fromJson(jsonDecode(order))).toList();
//   }
//
//   Future<void> clearOrders() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_orderKey);
//   }
// }
