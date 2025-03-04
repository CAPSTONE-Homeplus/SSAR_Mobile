import 'package:home_clean/core/base/base_model.dart';

import '../entities/user/user.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);
  Future<BaseResponse<User>> getUsersBySharedWallet(
      String walletId,
      String? search,
      String? orderBy,
      int? page,
      int? size,);
  Future<User> getUserByPhone(String phone);
}