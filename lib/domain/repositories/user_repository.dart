import 'package:home_clean/core/base/base_model.dart';

import '../entities/user/user.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);

  Future<BaseResponse<User>> getUsersBySharedWallet(
    String walletId,
    int? page,
    int? size,
  );

  Future<User> getUserByPhone(String phone);

  Future<bool> checkInfo(String? phoneNumber, String? email, String? username);

  Future<bool> updateProfile(
    String? fullName,
    String? buildingCode,
    String? houseCode,
    String? phoneNumber,
    String? email,
  );
}
