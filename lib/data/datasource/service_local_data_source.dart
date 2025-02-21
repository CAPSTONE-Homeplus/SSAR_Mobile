import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocalDataSource {
  final String _serviceKey = dotenv.env['SERVICE_KEY'] ?? 'default_user_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveService(Map<String, dynamic> serviceData) async {
    String serviceJson = jsonEncode(serviceData);
    await _secureStorage.write(key: _serviceKey, value: serviceJson);
  }

  Future<Map<String, dynamic>?> getService() async {
    String? serviceJson = await _secureStorage.read(key: _serviceKey);
    if (serviceJson == null) return null;
    return jsonDecode(serviceJson) as Map<String, dynamic>;
  }
  
  Future<void> clearService() async {
    await _secureStorage.delete(key: _serviceKey);
  }

}
