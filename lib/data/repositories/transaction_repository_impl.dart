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
import '../../core/request/request.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../models/auth/auth_model.dart';
import '../models/transaction/create_transaction_model.dart';
import '../models/transaction/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AuthLocalDataSource authLocalDataSource;
  final TransactionLocalDataSource transactionLocalDataSource;

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

      // Lấy dữ liệu từ cache
      BaseResponse<Transaction>? cachedData = await transactionLocalDataSource.getTransactions(userId);
      String? cachedUpdatedAt = (cachedData?.items.isNotEmpty == true)
          ? cachedData!.items[0].updatedAt
          : null;

      if (cachedUpdatedAt != null) {
        // Gọi API chỉ lấy phần tử đầu tiên để kiểm tra updatedAt
        final apiMetaResponse = await vinWalletRequest.get(
          '${ApiConstant.users}/$userId/transactions',
          queryParameters: {'page': 1, 'size': 1},
        );

        List<dynamic>? apiItems = apiMetaResponse.data?['items'];
        String apiUpdatedAt = (apiItems != null && apiItems.isNotEmpty)
            ? apiItems[0]['updatedAt'] ?? ''
            : '';

        if (cachedUpdatedAt == apiUpdatedAt) {
          print("📦 Dữ liệu từ cache (Không có thay đổi)");
          return BaseResponse(
            size: cachedData!.size,
            page: cachedData.page,
            total: cachedData.total,
            totalPages: cachedData.totalPages,
            items: cachedData.items,
          );
        }
      }

      print("🌍 Gọi API mới vì dữ liệu đã thay đổi!");
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
        List<dynamic> data = response.data['items'] ?? [];
        List<Transaction> transactions = data
            .map((item) => TransactionMapper.toEntity(TransactionModel.fromJson(item)))
            .toList();

        // Lấy updatedAt từ phần tử đầu tiên (nếu có)
        String? updatedAt = transactions.isNotEmpty ? transactions[0].updatedAt : null;

        // Chỉ lưu cache nếu updatedAt không null
        if (updatedAt != null) {
          await transactionLocalDataSource.saveTransactions(userId, response.data, updatedAt);
        }

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
  Future<BaseResponse<Transaction>> getTransactionByUserWallet(String walletId, String? search, String? orderBy, int? page, int? size) async {
    try {
      String userId = await _getUserId();

      final response = await vinWalletRequest.get(
        '${ApiConstant.users}/$userId/transactions/$walletId',
        queryParameters: {
          'id': userId,
          'walletId': walletId,
          'search': search,
          'orderBy': orderBy,
          'page': page,
          'size': size,
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
}
