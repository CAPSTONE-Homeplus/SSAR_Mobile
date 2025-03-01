import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/data/datasource/wallet_local_data_source.dart';
import 'package:home_clean/data/mappers/auth/auth_mapper.dart';
import 'package:home_clean/data/mappers/wallet_mapper.dart';
import 'package:home_clean/data/models/wallet/wallet_model.dart';

import '../../core/exception/exception_handler.dart';
import '../../core/helper/network_helper.dart';
import '../../core/request/request.dart';
import '../../../domain/entities/wallet/wallet.dart';
import '../../../domain/repositories/wallet_repository.dart';
import '../../core/constant/api_constant.dart';
import '../../domain/entities/user/user.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/user_local_datasource.dart';
import '../mappers/user/user_mapper.dart';
import '../models/auth/auth_model.dart';
import '../models/user/user_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  final AuthLocalDataSource authLocalDataSource;
  final UserLocalDatasource userLocalDatasource;
  final NetworkHelper _connectivity = NetworkHelper();
  final WalletLocalDataSource localDataSource;

  WalletRepositoryImpl({
    required this.authLocalDataSource,
    required this.userLocalDatasource,
    required this.localDataSource,
  });
  @override
  Future<BaseResponse<Wallet>> getWalletByUser(
      int? page,
      int? size) async {
    try {
      bool isOnline = await _connectivity.checkInternetConnection();

      if (!isOnline) {
        return _getCachedWallets();
      }

      AuthModel? authModel = AuthMapper.toModel(await authLocalDataSource.getAuth() ?? {});
      String userId = authModel.userId ?? '';

      final response = await vinWalletRequest.get(
        '${ApiConstant.users}/$userId/wallets',
        queryParameters: {
          'id': userId,
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];
        await localDataSource.saveWallet(response.data);

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

  Future<User> getUserFromLocal() async{
    try {
      UserModel? userModel = UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      User user = UserMapper.toEntity(userModel);
      return user;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  Future<BaseResponse<Wallet>> _getCachedWallets() async {
    Map<String, dynamic>? cachedData = await localDataSource.getWallet();
    if (cachedData == null || cachedData['items'] == null) {
      return BaseResponse<Wallet>(size: 0, page: 0, total: 0, totalPages: 0, items: []);
    }
    return BaseResponse<Wallet>(
      size: cachedData['size'] ?? 0,
      page: cachedData['page'] ?? 0,
      total: cachedData['total'] ?? 0,
      totalPages: cachedData['totalPages'] ?? 0,
      items: (cachedData['items'] as List)
          .map((item) => WalletMapper.toEntity(WalletModel.fromJson(item)))
          .toList(),
    );
  }

}