// Generic cache manager for API responses
import 'package:home_clean/core/request/request.dart';

import '../base/base_model.dart';
import '../constant/constant.dart';
import '../exception/exception_handler.dart';

class CacheManager<T> {
  final String cacheKey;
  final Future<String> Function() getUserId;
  final Future<BaseResponse<T>?> Function(String userId) getCachedData;
  final Future<void> Function(String userId, Map<String, dynamic> data, String updatedAt) saveToCache;
  final T Function(Map<String, dynamic>) fromJson;
  final String baseUrl;

  CacheManager({
    required this.cacheKey,
    required this.getUserId,
    required this.getCachedData,
    required this.saveToCache,
    required this.fromJson,
    required this.baseUrl,
  });

  Future<BaseResponse<T>> getDataWithCache({
    String? search,
    String? orderBy,
    int? page,
    int? size,
    bool forceRefresh = false,
  }) async {
    try {
      String userId = await getUserId();

      if (!forceRefresh) {
        // Try to get cached data
        BaseResponse<T>? cachedData = await getCachedData(userId);
        String? cachedUpdatedAt = (cachedData?.items.isNotEmpty == true)
            ? (cachedData!.items[0] as dynamic).updatedAt
            : null;

        if (cachedUpdatedAt != null) {
          // Check if data has changed by fetching only the first item
          final apiMetaResponse = await vinWalletRequest.get(
            '$baseUrl/$userId/$cacheKey',
            queryParameters: {'page': 1, 'size': 1},
          );

          List<dynamic>? apiItems = apiMetaResponse.data?['items'];
          String apiUpdatedAt = (apiItems != null && apiItems.isNotEmpty)
              ? apiItems[0]['updatedAt'] ?? ''
              : '';

          if (cachedUpdatedAt == apiUpdatedAt) {
            print("📦 Using cached data (No changes)");
            return cachedData!;
          }
        }
      }

      print("🌍 Fetching new data from API!");
      final response = await vinWalletRequest.get(
        '$baseUrl/$userId/$cacheKey',
        queryParameters: {
          'id': userId,
          'search': search,
          'orderBy': orderBy,
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];
        List<T> items = data.map((item) => fromJson(item)).toList();

        // Get updatedAt from first item if available
        String? updatedAt = (items.isNotEmpty)
            ? (items[0] as dynamic).updatedAt
            : null;

        // Save to cache if updatedAt exists
        if (updatedAt != null) {
          await saveToCache(userId, response.data, updatedAt);
        }

        return BaseResponse<T>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: items,
        );
      }

      throw ApiException(
        code: response.statusCode ?? -1,
        message: response.data?['message'] ?? 'Unknown error',
        description: response.data?['description'],
        timestamp: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}