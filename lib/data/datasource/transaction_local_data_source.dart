import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/base/base_model.dart';
import '../../domain/entities/transaction/transaction.dart';
import '../mappers/transaction/transaction_mapper.dart';
import '../models/transaction/transaction_model.dart';

class TransactionLocalDataSource {
  Future<void> saveTransactions(
      String userId, Map<String, dynamic> data, String updatedAt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cacheKey = 'transactions_$userId';

    await prefs.setString(cacheKey, json.encode(data));
    await prefs.setString('$cacheKey-updatedAt', updatedAt);
  }

  Future<BaseResponse<Transaction>?> getTransactions(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cacheKey = 'transactions_$userId';
    String? cachedData = prefs.getString(cacheKey);

    if (cachedData != null) {
      Map<String, dynamic> decodedData = json.decode(cachedData);
      List<Transaction> transactions = (decodedData['items'] as List)
          .map((item) =>
          TransactionMapper.toEntity(TransactionModel.fromJson(item)))
          .toList();

      return BaseResponse<Transaction>(
        size: decodedData['size'] ?? 0,
        page: decodedData['page'] ?? 0,
        total: decodedData['total'] ?? 0,
        totalPages: decodedData['totalPages'] ?? 0,
        items: transactions,
      );
    }
    return null;
  }

  Future<String?> getUpdatedAt(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('transactions_$userId-updatedAt');
  }
}
