import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class ServiceLocalDataSource {
//   static final String _serviceKey = dotenv.env['SERVICE_KEY'] ?? 'default_service_key';
//   static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
//
//   Future<void> saveService(Map<String, dynamic> serviceData) async {
//     try {
//       if (serviceData.isNotEmpty) {
//         String serviceJson = jsonEncode(serviceData);
//         await _secureStorage.write(key: _serviceKey, value: serviceJson);
//       }
//     } catch (e) {
//       print('Lỗi khi lưu dịch vụ: $e');
//     }
//   }
//
//   Future<Map<String, dynamic>?> getServices() async {
//     try {
//       String? serviceJson = await _secureStorage.read(key: _serviceKey);
//       if (serviceJson == null || serviceJson.isEmpty) return null;
//       return jsonDecode(serviceJson) as Map<String, dynamic>;
//     } catch (e) {
//       print('Lỗi khi đọc dịch vụ: $e');
//       return null;
//     }
//   }
//
//   Future<void> clearService() async {
//     try {
//       await _secureStorage.delete(key: _serviceKey);
//     } catch (e) {
//       print('Lỗi khi xóa dịch vụ: $e');
//     }
//   }
// }
