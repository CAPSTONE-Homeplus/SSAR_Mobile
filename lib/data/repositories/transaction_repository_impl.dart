import 'package:dio/dio.dart';
import 'package:home_clean/data/mappers/transaction/create_transaction_mapper.dart';
import 'package:home_clean/data/models/transaction/transaction_model.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';
import '../../core/api_constant.dart';
import '../../core/exception_handler.dart';
import '../../core/request.dart';
import '../../domain/entities/auth/authen.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/user_local_datasource.dart';
import '../models/authen/authen_model.dart';
import '../models/transaction/create_transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AuthLocalDataSource authLocalDataSource;
  final UserLocalDatasource userLocalDatasource;

  TransactionRepositoryImpl({
    required this.authLocalDataSource,
    required this.userLocalDatasource,
  });
  @override
  Future<Transaction> saveTransaction(CreateTransaction transaction) async {
    try {
      AuthenModel? authModel = await authLocalDataSource.getAuth();
      String userId = authModel?.userId ?? '';
      String token = authModel?.accessToken ?? '';
      CreateTransactionModel trans = CreateTransactionMapper.toModel(transaction);
      trans.userId = userId;
      final response = await vinWalletRequest.post(
        ApiConstant.TRANSACTIONS,
        data: trans.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
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
}
