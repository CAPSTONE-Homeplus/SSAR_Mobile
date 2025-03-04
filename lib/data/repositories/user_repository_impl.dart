import 'package:home_clean/core/base/base_model.dart';
import '../../core/constant/constants.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/data/mappers/user/user_mapper.dart';
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
  Future<BaseResponse<User>> getUsersBySharedWallet(String walletId, String? search, String? orderBy, int? page, int? size) async {
    try {
      final userResponse = await vinWalletRequest.get(
        '${ApiConstant.wallets}/$walletId/users-in-sharewallet',
        queryParameters: {
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize,
        },
      );
      if (userResponse.statusCode == 200 && userResponse.data != null) {
        List<UserModel> userModelList = (userResponse.data['items'] as List)
            .map((e) => UserMapper.toModel(e))
            .toList();
        List<User> userList = userModelList.map((e) => UserMapper.toEntity(e)).toList();
        return BaseResponse<User>(
          size: userResponse.data['size'] ?? 0,
          page: userResponse.data['page'] ?? 0,
          total: userResponse.data['total'] ?? 0,
          totalPages: userResponse.data['totalPages'] ?? 0,
          items: userList,
        );
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
  Future<User> getUserByPhone(String phone) async {
    try {
      final userResponse = await vinWalletRequest.get(
        '${ApiConstant.users}/phone-number/$phone',
        queryParameters: {
          'phoneNumber': phone,
        },
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
}