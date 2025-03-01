import 'package:home_clean/data/datasource/transaction_local_data_source.dart';
import 'package:home_clean/data/mappers/auth/auth_mapper.dart';
import 'package:home_clean/data/mappers/transaction/create_transaction_mapper.dart';
import 'package:home_clean/data/mappers/transaction/transaction_mapper.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';
import '../../core/base/base_model.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constant.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/helper/network_helper.dart';
import '../../core/request/request.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../models/auth/auth_model.dart';
import '../models/transaction/create_transaction_model.dart';
import '../models/transaction/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AuthLocalDataSource authLocalDataSource;
  final TransactionLocalDataSource transactionLocalDataSource;
  final NetworkHelper _connectivity = NetworkHelper();


  TransactionRepositoryImpl({
    required this.authLocalDataSource,
    required this.transactionLocalDataSource,
  });

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


  @override
  Future<Transaction> saveTransaction(CreateTransaction transaction) async {
    try {
      AuthModel? authModel = AuthMapper.toModel(await authLocalDataSource.getAuth() ?? {});
      String userId = authModel.userId ?? '';
      CreateTransactionModel trans = CreateTransactionMapper.toModel(transaction);
      trans.userId = userId;
      final response = await vinWalletRequest.post(
        ApiConstant.transactions,
        data: trans.toJson(),
      );

      if (response.statusCode == 201 && response.data != null) {
        transactionLocalDataSource.saveTransactions(userId, response.data);
        return Transaction(
          id: response.data['id'],
          walletId: response.data['walletId'],
          userId: response.data['userId'],
          paymentMethodId: response.data['paymentMethodId'],
          amount: response.data['amount'],
          type: response.data['type'],
          paymentUrl: response.data['paymentUrl'],
          note: response.data['note'],
          transactionDate: response.data['transactionDate'],
          status: response.data['status'],
          createdAt: response.data['createdAt'],
          updatedAt: response.data['updatedAt'],
          code: response.data['code'],
          categoryId: response.data['categoryId'],
          orderId: response.data['orderId'],
        );
      } else {
        throw ApiException(
          traceId: response.data?['traceId'] ?? '',
          code: response.data?['code'] ?? 'UNKNOWN_ERROR',
          message: response.data?['message'] ?? 'Lỗi từ máy chủ',
          description: response.data?['description'] ?? '',
          timestamp: response.data?['timestamp'] ?? '',
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<BaseResponse<Transaction>> getTransactionByUser(
      String? search, String? orderBy, int? page, int? size) async {
    try {
      String userId = await _getUserId();

      bool isConnected = await _connectivity.checkInternetConnection();
      if (!isConnected) {
        return await _getCachedTransactions(userId);
      }

      final response = await vinWalletRequest.get(
        '${ApiConstant.users}/$userId/transactions',
        queryParameters: {
          'id': userId,
          'search': search,
          'orderBy': orderBy,
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data as Map<String, dynamic>;
        List<dynamic> data = rawData['items'] ?? [];

        List<Transaction> transactions = data
            .map((item) => TransactionMapper.toEntity(TransactionModel.fromJson(item)))
            .toList();

        await transactionLocalDataSource.saveTransactions(userId, rawData);

        return BaseResponse<Transaction>(
          size: rawData['size'] ?? 0,
          page: rawData['page'] ?? 0,
          total: rawData['total'] ?? 0,
          totalPages: rawData['totalPages'] ?? 0,
          items: transactions,
        );
      } else {
        throw ApiException(
          code: response.statusCode ?? -1,
          message: response.data?['message'] ?? 'Lỗi không xác định',
          description: response.data?['description'],
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }



  @override
  Future<BaseResponse<Transaction>> getTransactionByUserWallet(String walletId, String? search, String? orderBy, int? page, int? size) async {
    try {
      String userId = await _getUserId();

      final response = await vinWalletRequest.get(
        '${ApiConstant.users}/$userId/transactions/$walletId',
        queryParameters: {
          'id': userId,
          'walletId': walletId,
          'search': search ?? '',
          'orderBy': orderBy ?? '',
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<Transaction> transactions = data
            .map((item) => TransactionMapper.toEntity(TransactionModel.fromJson(item)))
            .toList();

        return BaseResponse<Transaction>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: transactions,
        );
      }

      throw ApiException(
        code: response.statusCode ?? -1,
        message: response.data?['message'] ?? 'Lỗi không xác định',
        description: response.data?['description'],
        timestamp: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  Future<BaseResponse<Transaction>> _getCachedTransactions(String userId) async {
    try {
      BaseResponse<Transaction>? cachedData = await transactionLocalDataSource.getTransactions(userId);
      if (cachedData == null) {
        return BaseResponse<Transaction>(size: 0, page: 0, total: 0, totalPages: 0, items: []);
      }
      return cachedData;
    } catch (e) {
      return BaseResponse<Transaction>(size: 0, page: 0, total: 0, totalPages: 0, items: []);
    }
  }

}
