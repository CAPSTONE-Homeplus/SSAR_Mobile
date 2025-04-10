import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/data/mappers/auth/auth_mapper.dart';
import 'package:home_clean/data/mappers/wallet/wallet_mapper.dart';
import 'package:home_clean/data/models/wallet/wallet_model.dart';
import 'package:home_clean/domain/entities/contribution_statistics/contribution_statistics.dart';

import '../../../domain/entities/wallet/wallet.dart';
import '../../../domain/repositories/wallet_repository.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constants.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/request/request.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../datasource/local/user_local_datasource.dart';
import '../mappers/user/user_mapper.dart';

class WalletRepositoryImpl implements WalletRepository {
  final AuthLocalDataSource authLocalDataSource;
  final UserLocalDatasource userLocalDatasource;

  WalletRepositoryImpl({
    required this.authLocalDataSource,
    required this.userLocalDatasource,
  });

  @override
  Future<BaseResponse<Wallet>> getWalletByUser(int? page, int? size) async {
    try {
      String userId = await _getUserId();
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
            .map((item) => WalletMapper.toEntity(WalletModel.fromJson(item)))
            .toList();

        walletList.sort((a, b) =>
            (b.type == 'Personal' ? 1 : 0) - (a.type == 'Personal' ? 1 : 0));

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
      final user =
          UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      String? userId = user.id;
      final response = await vinWalletRequest.post(
        '${ApiConstant.users}/$userId/share-wallet',
        queryParameters: {
          'id': userId,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        Wallet wallet =
            WalletMapper.toEntity(WalletModel.fromJson(response.data));
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
        Wallet wallet =
            WalletMapper.toEntity(WalletModel.fromJson(response.data));
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
  Future<bool> deleteSharedWalletByAdmin(String walletId) async {
    try {
      final response = await vinWalletRequest.put(
        '${ApiConstant.wallets}/$walletId/dissolution',
        queryParameters: {
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
  Future<ContributionStatistics> getContributionStatistics(
      String walletId, int days) async {
    try {
      final response = await vinWalletRequest.get(
        '${ApiConstant.wallets}/$walletId/contribution-statistics',
        queryParameters: {
          'id': walletId,
          'days': days,
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        ContributionStatistics contributionStatistics =
            ContributionStatistics.fromJson(response.data);
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

  @override
  Future<bool> transferToSharedWallet(
      String sharedWalletId, String personalWalletId, int amount) async {
    try {
      final response = await vinWalletRequest.put(
        '${ApiConstant.wallets}/transfer-personal-to-shared',
        data: {
          'sharedWalletId': sharedWalletId,
          'personalWalletId': personalWalletId,
          'amount': amount,
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

  Future<String> _getUserId() async {
    final authModel = AuthMapper.toModel(
      await authLocalDataSource.getAuth() ?? {},
    );
    final userId = authModel.userId;

    if (userId == null || userId.isEmpty) {
      throw Exception('User ID is empty');
    }

    return userId;
  }
}
