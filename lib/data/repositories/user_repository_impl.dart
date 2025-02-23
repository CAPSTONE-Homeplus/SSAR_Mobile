import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/data/mappers/user/user_mapper.dart';
import 'package:home_clean/domain/entities/user/create_user.dart';
import 'package:home_clean/domain/entities/user/user.dart';
import 'package:home_clean/domain/repositories/user_repository.dart';

import '../../core/constant/api_constant.dart';
import '../../core/request/request.dart';
import '../datasource/user_local_datasource.dart';
import '../models/user/user_model.dart';

class UserRepositoryImpl implements UserRepository {

  final UserLocalDatasource userLocalDatasource;

  UserRepositoryImpl({
    required this.userLocalDatasource,
  });

  @override
  Future<User> getUser(String userId) async {
    try {
      final userResponse = await vinWalletRequest.get(
        '${ApiConstant.users}/$userId',
      );

      if (userResponse.statusCode == 200 && userResponse.data != null) {
        await userLocalDatasource.saveUser(userResponse.data);
        UserModel userModel = UserMapper.toModel(userResponse.data);
        return UserMapper.toEntity(userModel);
      } else {
        throw ApiException(
          traceId: userResponse.data['traceId'],
          code: userResponse.data['code'],
          message: userResponse.data['message'] ?? 'Lỗi từ máy chủ',
          description: userResponse.data['description'],
          timestamp: userResponse.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<User> createAccount(CreateUser createUser) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }
}