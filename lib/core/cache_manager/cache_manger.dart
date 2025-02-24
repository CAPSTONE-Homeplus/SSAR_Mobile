import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheManager<T> {
  Future<void> saveToCache(String key, List<T> items);
  Future<List<T>?> getFromCache(String key);
  Future<void> clearCache(String key);
}

class SharedPreferencesCacheManager<T> implements CacheManager<T> {
  final T Function(Map<String, dynamic>) fromJson;
  final String cachePrefix;

  SharedPreferencesCacheManager({required this.fromJson, required this.cachePrefix});

  @override
  Future<void> saveToCache(String key, List<T> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items.map((e) => (e as dynamic).toJson()).toList());
    await prefs.setString('$cachePrefix$key', jsonString);
  }

  @override
  Future<List<T>?> getFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$cachePrefix$key');
    if (jsonString == null) return null;
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => fromJson(e)).toList();
  }

  @override
  Future<void> clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$cachePrefix$key');
  }
}
