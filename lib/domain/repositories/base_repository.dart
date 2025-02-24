import '../../core/base/base_model.dart';
import '../../core/cache_manager/cache_manger.dart';
import '../../core/exception/exception_handler.dart';
import '../../data/datasource/local_data_source.dart';

abstract class BaseRepository<T> {
  final CacheManager<T> cacheManager;
  final LocalDataSource<T> localDataSource;

  BaseRepository({
    required this.cacheManager,
    required this.localDataSource,
  });

  Future<String> getUserId();

  Future<BaseResponse<T>> getDataWithCache({
    required String apiPath,
    String? search,
    String? orderBy,
    int? page,
    int? size,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final String userId = await getUserId();

      final BaseResponse<T>? cachedData = await localDataSource.getData(userId);
      final String? cachedUpdatedAt = cachedData?.items.isNotEmpty == true
          ? (cachedData!.items.first as dynamic).updatedAt
          : null;


      if (cachedUpdatedAt != null) {
        final String apiUpdatedAt = await fetchUpdatedAt(apiPath, userId);
        if (cachedUpdatedAt == apiUpdatedAt) {
          print("📦 Dữ liệu từ cache (Không có thay đổi)");
          return cachedData!;
        }
      }

      // 🌍 Gọi API mới vì dữ liệu đã thay đổi!
      print("🌍 Gọi API mới...");
      final responseData = await fetchDataFromApi(
        apiPath: apiPath,
        userId: userId,
        search: search,
        orderBy: orderBy,
        page: page,
        size: size,
      );

      final List<T> items = (responseData['items'] as List)
          .map((item) => fromJson(item))
          .toList();

      final String? updatedAt = items.isNotEmpty
          ? (items.first as dynamic).updatedAt
          : null;

      if (updatedAt != null) {
        await localDataSource.saveData(userId, responseData, updatedAt);
      }

      return BaseResponse<T>(
        size: responseData['size'] ?? 0,
        page: responseData['page'] ?? 0,
        total: responseData['total'] ?? 0,
        totalPages: responseData['totalPages'] ?? 0,
        items: items,
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  Future<String> fetchUpdatedAt(String apiPath, String userId);

  Future<Map<String, dynamic>> fetchDataFromApi({
    required String apiPath,
    required String userId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  });
}
