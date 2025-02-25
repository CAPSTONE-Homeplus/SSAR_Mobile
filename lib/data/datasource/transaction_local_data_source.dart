import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/base/base_model.dart';
import '../../domain/entities/transaction/transaction.dart';
import '../mappers/transaction/transaction_mapper.dart';
import '../models/transaction/transaction_model.dart';

class TransactionLocalDataSource {
  final String _transactionKey = dotenv.env['TRANSACTIONS_KEY'] ?? 'default_transaction_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String _getCacheKey(String userId) => '\${_transactionKey}_\$userId';

  Future<Map<String, dynamic>?> saveTransactions(
      String userId, Map<String, dynamic> data) async {
    await _secureStorage.write(key: _getCacheKey(userId), value: json.encode(data));
    return getRawTransactions(userId);
  }

  Future<BaseResponse<Transaction>?> getTransactions(String userId) async {
    Map<String, dynamic>? rawData = await getRawTransactions(userId);
    if (rawData == null) return null;

    List<Transaction> transactions = (rawData['items'] as List)
        .map((item) => TransactionMapper.toEntity(TransactionModel.fromJson(item)))
        .toList();

    return BaseResponse<Transaction>(
      size: rawData['size'] ?? 0,
      page: rawData['page'] ?? 0,
      total: rawData['total'] ?? 0,
      totalPages: rawData['totalPages'] ?? 0,
      items: transactions,
    );
  }

  Future<Map<String, dynamic>?> getRawTransactions(String userId) async {
    String? cachedData = await _secureStorage.read(key: _getCacheKey(userId));
    return cachedData != null ? json.decode(cachedData) : null;
  }

  Future<void> clearTransactions(String userId) async {
    await _secureStorage.delete(key: _getCacheKey(userId));
  }
}
