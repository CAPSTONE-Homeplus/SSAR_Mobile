import '../../core/base/base_model.dart';

abstract class LocalDataSource<T> {
  Future<BaseResponse<T>?> getData(String userId);
  Future<void> saveData(String userId, Map<String, dynamic> data, String updatedAt);
}
