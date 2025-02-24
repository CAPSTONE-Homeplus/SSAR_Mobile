import 'package:home_clean/core/base/base_model.dart';

import '../../domain/entities/transaction/transaction.dart';
import '../request/request_cache.dart';

class TransactionCacheManager implements CacheManager<Transaction> {
  @override
  // TODO: implement baseUrl
  String get baseUrl => throw UnimplementedError();

  @override
  // TODO: implement cacheKey
  String get cacheKey => throw UnimplementedError();

  @override
  // TODO: implement fromJson
  Transaction Function(Map<String, dynamic> p1) get fromJson => throw UnimplementedError();

  @override
  // TODO: implement getCachedData
  Future<BaseResponse<Transaction>?> Function(String userId) get getCachedData => throw UnimplementedError();

  @override
  Future<BaseResponse<Transaction>> getDataWithCache({String? search, String? orderBy, int? page, int? size, bool forceRefresh = false}) {
    // TODO: implement getDataWithCache
    throw UnimplementedError();
  }

  @override
  // TODO: implement getUserId
  Future<String> Function() get getUserId => throw UnimplementedError();

  @override
  // TODO: implement saveToCache
  Future<void> Function(String userId, Map<String, dynamic> data, String updatedAt) get saveToCache => throw UnimplementedError();

  
}
