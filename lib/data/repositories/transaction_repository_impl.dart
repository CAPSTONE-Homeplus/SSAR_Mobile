import 'package:home_clean/data/datasource/local/transaction_local_data_source.dart';
import 'package:home_clean/data/mappers/auth/auth_mapper.dart';
import 'package:home_clean/data/mappers/transaction/create_transaction_mapper.dart';
import 'package:home_clean/data/mappers/transaction/transaction_mapper.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';
import '../../core/base/base_model.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constants.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/helper/network_helper.dart';
import '../../core/request/request.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../models/auth/auth_model.dart';
import '../models/transaction/create_transaction_model.dart';
import '../models/transaction/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AuthLocalDataSource authLocalDataSource;

  TransactionRepositoryImpl({
    required this.authLocalDataSource,
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
      // Get authenticated user ID
      final authModel = AuthMapper.toModel(
          await authLocalDataSource.getAuth() ?? {}
      );
      final userId = authModel.userId ?? '';

      // Prepare transaction model
      final transactionModel = CreateTransactionMapper.toModel(transaction)
        ..userId = userId;

      // Make API request
      final response = await vinWalletRequest.post(
        ApiConstant.transactions,
        data: transactionModel.toJson(),
      );

      // Validate response
      if (response.statusCode != 201 || response.data == null) {
        throw ApiException(
          traceId: response.data?['traceId'] ?? '',
          code: response.data?['code'] ?? 'UNKNOWN_ERROR',
          message: response.data?['message'] ?? 'Lỗi từ máy chủ',
          description: response.data?['description'] ?? '',
          timestamp: response.data?['timestamp'] ?? '',
        );
      }

      // Map response to Transaction model
      return _mapResponseToTransaction(response.data);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

// Extract mapping logic to a separate method for better readability
  Transaction _mapResponseToTransaction(Map<String, dynamic> data) {
    return Transaction(
      id: data['id'],
      walletId: data['walletId'],
      userId: data['userId'],
      paymentMethodId: data['paymentMethodId'],
      amount: data['amount'],
      type: data['type'],
      paymentUrl: data['paymentUrl'],
      note: data['note'],
      transactionDate: data['transactionDate'],
      status: data['status'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      code: data['code'],
      categoryId: data['categoryId'],
      orderId: data['orderId'],
    );
  }

  @override
  Future<BaseResponse<Transaction>> getTransactionByUser(
      String? search, String? orderBy, int? page, int? size) async {
    try {
      String userId = await _getUserId();
      final response = await vinWalletRequest.get(
        '${ApiConstant.users}/$userId/transactions',
        queryParameters: {
          'id': userId,
          'search': search ?? '',
          'orderBy': orderBy ?? '',
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data as Map<String, dynamic>;
        List<dynamic> data = rawData['items'] ?? [];

        List<Transaction> transactions = data
            .map((item) => TransactionMapper.toEntity(TransactionModel.fromJson(item)))
            .toList();

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

  @override
  Future<BaseResponse<Transaction>> getTransactionByWallet(String walletId, String? search, String? orderBy, int? page, int? size) async {
    try {
      final response = await vinWalletRequest.get(
        '${ApiConstant.wallets}/$walletId/transactions',
        queryParameters:
        {
          'id': walletId,
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
