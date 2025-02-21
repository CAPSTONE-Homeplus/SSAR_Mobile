import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/data/mappers/auth/auth_mapper.dart';
import 'package:home_clean/data/mappers/wallet_mapper.dart';
import 'package:home_clean/data/models/wallet/wallet_model.dart';

import '../../../core/api_constant.dart';
import '../../../core/exception_handler.dart';
import '../../../core/request.dart';
import '../../../domain/entities/wallet/wallet.dart';
import '../../../domain/repositories/wallet_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/user_local_datasource.dart';
import '../models/auth/auth_model.dart';

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
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<Wallet> walletList = data
            .map((item) => WalletMapper.toEntity(
            WalletModel.fromJson(item)))
            .toList();

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


}