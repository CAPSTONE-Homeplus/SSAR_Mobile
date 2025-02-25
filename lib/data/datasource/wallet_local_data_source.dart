import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletLocalDataSource {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static final String _walletKey = dotenv.env['WALLET_KEY'] ?? 'default_wallet_key';

  Future<void> saveWallet(Map<String, dynamic> walletData) async {
    String walletJson = jsonEncode(walletData);
    await _secureStorage.write(key: _walletKey, value: walletJson);
  }

  Future<Map<String, dynamic>?> getWallet() async {
    String? walletJson = await _secureStorage.read(key: _walletKey);
    if (walletJson == null) return null;
    return jsonDecode(walletJson) as Map<String, dynamic>;
  }

  Future<void> clearWallet() async {
    await _secureStorage.delete(key: _walletKey);
  }
}
