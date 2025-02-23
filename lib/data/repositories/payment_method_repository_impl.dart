import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/mappers/payment_mapper.dart';

import '../../core/constant/api_constant.dart';
import '../../core/exception/exception_handler.dart';
import '../../domain/entities/payment_method/payment_method.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../models/payment_method/payment_method_model.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  @override
  Future<BaseResponse<PaymentMethod>> getPaymentMethods(String? search, String? orderBy, int? page, int? size) async {
    try {
      final response = await vinWalletRequest.get(
          ApiConstant.paymentMethods,
          queryParameters: {
            'search': search,
            'orderBy': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<PaymentMethod> paymentMethods = data
            .map((item) => PaymentMapper.toEntity(
            PaymentMethodModel.fromJson(item)))
            .toList();

        return BaseResponse<PaymentMethod>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: paymentMethods,
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