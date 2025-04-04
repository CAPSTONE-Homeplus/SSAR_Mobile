import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/data/datasource/local/wallet_local_data_source.dart';
import 'package:home_clean/data/mappers/auth/auth_mapper.dart';
import 'package:home_clean/data/mappers/wallet/wallet_mapper.dart';
import 'package:home_clean/data/models/wallet/wallet_model.dart';
import 'package:home_clean/domain/entities/contribution_statistics/contribution_statistics.dart';

import '../../core/constant/constants.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/helper/network_helper.dart';
import '../../core/request/request.dart';
import '../../../domain/entities/wallet/wallet.dart';
import '../../../domain/repositories/wallet_repository.dart';
import '../../core/constant/api_constant.dart';
import '../../domain/entities/user/user.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../datasource/local/user_local_datasource.dart';
import '../mappers/user/user_mapper.dart';
import '../models/auth/auth_model.dart';
import '../models/user/user_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  final AuthLocalDataSource authLocalDataSource;
  final UserLocalDatasource userLocalDatasource;

  WalletRepositoryImpl({
    required this.authLocalDataSource,
    required this.userLocalDatasource,
  });
  @override
  Future<BaseResponse<Wallet>> getWalletByUser(
      int? page,
      int? size) async {
    try {

      AuthModel? authModel = AuthMapper.toModel(await authLocalDataSource.getAuth() ?? {});
      String userId = authModel.userId ?? '';

      final response = await vinWalletRequest.get(
        '${ApiConstant.users}/$userId/wallets',
        queryParameters: {
          'id': userId,
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<Wallet> walletList = data
            .map((item) => WalletMapper.toEntity(
            WalletModel.fromJson(item)))
            .toList();

        walletList.sort((a, b) => (b.type == 'Personal' ? 1 : 0) - (a.type == 'Personal' ? 1 : 0));


        return BaseResponse<Wallet>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: walletList,
        );
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }


  @override
  Future<Wallet> createSharedWallet() async {
    try {
      User user = await getUserFromLocal();
      String? userId = user.id;

      final response = await vinWalletRequest.post(
        '${ApiConstant.users}/$userId/share-wallet',
        queryParameters:
        {
          'id': userId,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        Wallet wallet = WalletMapper.toEntity(WalletModel.fromJson(response.data));
        return wallet;
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }


  @override
  Future<bool> inviteMember(String walletId, String userId) async {
    try {
      final response = await vinWalletRequest.post(
        '${ApiConstant.wallets}/invite-member',
        data: {
          'userId': userId,
          'walletId': walletId,
        },
      );
      if (response.statusCode == 201 && response.data == true) {
        return true;
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  Future<User> getUserFromLocal() async{
    try {
      UserModel? userModel = UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      User user = UserMapper.toEntity(userModel);
      return user;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }


  @override
  Future<Wallet> changeOwner(String walletId, String userId) async {
    try {
      final response = await vinWalletRequest.patch(
        '${ApiConstant.wallets}/$walletId/change-owner/$userId',
        queryParameters: {
          'id': walletId,
          'userId': userId,
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        Wallet wallet = WalletMapper.toEntity(WalletModel.fromJson(response.data));
        return wallet;
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<bool> deleteUserFromWallet(String walletId, String userId) async {
    try {
      final response = await vinWalletRequest.delete(
        '${ApiConstant.wallets}/$walletId/$userId',
        queryParameters: {
          'userId': userId,
          'id': walletId,
        },
      );
      if (response.statusCode == 200 && response.data == true) {
        return true;
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
);
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ContributionStatistics> getContributionStatistics(String walletId, int days) async {
    try {
      final response = await vinWalletRequest.get(
        '${ApiConstant.wallets}/$walletId/contribution-statistics',
        queryParameters: {
          'id': walletId,
          'days': days,
        },
      );
      if (response.statusCode == 200 && response.data == true) {
        ContributionStatistics contributionStatistics = ContributionStatistics.fromJson(response.data);
        return contributionStatistics;
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }



}