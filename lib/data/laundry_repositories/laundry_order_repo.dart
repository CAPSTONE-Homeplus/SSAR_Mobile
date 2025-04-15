import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/datasource/local/auth_local_datasource.dart';
import '../../core/base/base_model.dart';
import '../../core/constant/api_constant.dart';
import '../../core/exception/exception_handler.dart';
import '../datasource/local/user_local_datasource.dart';
import '../mappers/auth/auth_mapper.dart';
import '../models/auth/auth_model.dart';

class LaundryOrderRepository {

  final AuthLocalDataSource authLocalDataSource;
  final UserLocalDatasource userLocalDatasource;

  LaundryOrderRepository({
    required this.authLocalDataSource,
    required this.userLocalDatasource,
  });

  Future<LaundryOrderDetailModel> createLaundryOrder(LaOrderRequest requestData) async {
    try {
      AuthModel? authModel = AuthMapper.toModel(await authLocalDataSource.getAuth() ?? {});
      String userId = authModel.userId ?? '';
      final accessToken = await authLocalDataSource.getAccessTokenFromStorage();
      vinLaundryRequest.options.headers['Authorization'] = 'Bearer $accessToken';
      final payload = {
        "name": requestData.name ?? 'Laundry Order',
        "userId": userId.toString(),
        "type": requestData.type ?? 'standard',
        "extraField": requestData.extraField ?? '',
        "appliedDiscountId": null,
        "orderDetailsRequest": requestData.orderDetailsRequest,
        "additionalServiceIds": requestData.additionalServiceIds,
      };
      final response = await vinLaundryRequest.post(
        ApiConstant.orders,
        data: payload,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        LaundryOrderDetailModel order = LaundryOrderDetailModel.fromJson(data);
        return order;
      } else {
        throw ApiException(
          traceId: response.data?['traceId'],
          code: response.data?['code'],
          message: response.data?['message'] ?? 'Lỗi từ máy chủ',
          description: response.data?['description'],
          timestamp: response.data?['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }


  Future<LaundryOrderDetailModel> getLaundryOrder(String orderId) async {

    try {
      final response = await vinLaundryRequest.get(
        '${ApiConstant.orders}/$orderId',
        queryParameters: {
          'id ': orderId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        LaundryOrderDetailModel order = LaundryOrderDetailModel.fromJson(data);
        return order;
      } else {
        throw ApiException(
          traceId: response.data?['traceId'],
          code: response.data?['code'],
          message: response.data?['message'] ?? 'Lỗi từ máy chủ',
          description: response.data?['description'],
          timestamp: response.data?['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}



class AdditionalService {
  String id;
  String serviceCode;
  String name;
  String description;
  double price;

  AdditionalService({
    required this.id,
    required this.serviceCode,
    required this.name,
    required this.description,
    required this.price,
  });

  factory AdditionalService.fromJson(Map<String, dynamic> json) {
    return AdditionalService(
      id: json['id'],
      serviceCode: json['serviceCode'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceCode': serviceCode,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}

class LaOrderRequest {
  String? name;
  String? userId;
  String? type;
  String? extraField;
  String? appliedDiscountId;
  List<OrderDetailsRequest>? orderDetailsRequest;
  List<String>? additionalServiceIds;

  LaOrderRequest(
      {this.name,
        this.userId,
        this.type,
        this.extraField,
        this.appliedDiscountId,
        this.orderDetailsRequest,
        this.additionalServiceIds});

  LaOrderRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userId = json['userId'];
    type = json['type'];
    extraField = json['extraField'];
    appliedDiscountId = json['appliedDiscountId'];
    if (json['orderDetailsRequest'] != null) {
      orderDetailsRequest = <OrderDetailsRequest>[];
      json['orderDetailsRequest'].forEach((v) {
        orderDetailsRequest!.add(new OrderDetailsRequest.fromJson(v));
      });
    }
    additionalServiceIds = json['additionalServiceIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['extraField'] = this.extraField;
    data['appliedDiscountId'] = this.appliedDiscountId;
    if (this.orderDetailsRequest != null) {
      data['orderDetailsRequest'] =
          this.orderDetailsRequest!.map((v) => v.toJson()).toList();
    }
    data['additionalServiceIds'] = this.additionalServiceIds;
    return data;
  }
}

class OrderDetailsRequest {
  String? itemTypeId;
  int? quantity;
  double? weight;
  String? notes;

  OrderDetailsRequest(
      {this.itemTypeId, this.quantity, this.weight, this.notes});

  OrderDetailsRequest.fromJson(Map<String, dynamic> json) {
    itemTypeId = json['itemTypeId'];
    quantity = json['quantity'];
    weight = json['weight'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemTypeId'] = this.itemTypeId;
    data['quantity'] = this.quantity;
    data['weight'] = this.weight;
    data['notes'] = this.notes;
    return data;
  }
}

class LaundryOrderDetailModel {
  final String id;
  final String? orderCode;
  final String? name;
  final String? userId;
  final double? balance;
  final String? currency;
  final String? type;
  final String? extraField;
  final double? totalAmount;
  final double? discountAmount;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? estimatedCompletionTime;
  final String? appliedDiscountId;
  final List<AdditionalService> orderAdditionalServicesResponse;
  final List<OrderDetailResponse> orderDetailsByKg;
  final List<OrderDetailResponse> orderDetailsByItem;

  String get statusName {
    switch (status) {
      case 'PENDING':
        return 'Đang chờ';
      case 'IN_PROGRESS':
        return 'Đang thực hiện';
      case 'COMPLETED':
        return 'Hoàn thành';
      case 'CANCELLED':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }


  LaundryOrderDetailModel({
    required this.id,
    this.orderCode,
    this.name,
    this.userId,
    this.balance,
    this.currency,
    this.type,
    this.extraField,
    this.totalAmount,
    this.discountAmount,
    this.orderDate,
    this.deliveryDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.estimatedCompletionTime,
    this.appliedDiscountId,
    this.orderAdditionalServicesResponse = const [],
    this.orderDetailsByKg = const [],
    this.orderDetailsByItem = const [],
  });

  factory LaundryOrderDetailModel.fromJson(Map<String, dynamic> json) {
    return LaundryOrderDetailModel(
      id: json['id'] as String,
      orderCode: json['orderCode'] as String?,
      name: json['name'] as String?,
      userId: json['userId'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      type: json['type'] as String?,
      extraField: json['extraField'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      estimatedCompletionTime: json['estimatedCompletionTime'] != null
          ? DateTime.parse(json['estimatedCompletionTime'])
          : null,
      appliedDiscountId: json['appliedDiscountId'] as String?,
      orderAdditionalServicesResponse: (json['orderAdditionalServicesResponse'] as List<dynamic>?)
          ?.map((e) => AdditionalService.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      orderDetailsByKg: (json['orderDetailsByKg'] as List<dynamic>?)
          ?.map((e) => OrderDetailResponse.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      orderDetailsByItem: (json['orderDetailsByItem'] as List<dynamic>?)
          ?.map((e) => OrderDetailResponse.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderCode': orderCode,
      'name': name,
      'userId': userId,
      'balance': balance,
      'currency': currency,
      'type': type,
      'extraField': extraField,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'orderDate': orderDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'estimatedCompletionTime': estimatedCompletionTime?.toIso8601String(),
      'appliedDiscountId': appliedDiscountId,
      'orderAdditionalServicesResponse': orderAdditionalServicesResponse.map((e) => e.toJson()).toList(),
      'orderDetailsByKg': orderDetailsByKg.map((e) => e.toJson()).toList(),
      'orderDetailsByItem': orderDetailsByItem.map((e) => e.toJson()).toList(),
    };
  }

}


class AdditionalServiceResponse {
  final String? id;
  final String? serviceCode;
  final String? name;
  final String? description;
  final double? price;

  AdditionalServiceResponse({
    this.id,
    this.serviceCode,
    this.name,
    this.description,
    this.price,
  });

  factory AdditionalServiceResponse.fromJson(Map<String, dynamic> json) {
    return AdditionalServiceResponse(
      id: json['id'],
      serviceCode: json['serviceCode'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble(),
    );
  }
}
class OrderDetailResponse {
  final String id;
  final String? itemTypeId;
  final int? quantity;
  final double? weight;
  final double? unitPrice;
  final double? subtotal;
  final String? notes;
  final double? actualWeight;
  final int? estimatedTime;
  final int? actualCompletionTime;
  final ItemTypeInOrderDetailResponse itemTypeResponse;

  OrderDetailResponse({
    required this.id,
    this.itemTypeId,
    this.quantity,
    this.weight,
    this.unitPrice,
    this.subtotal,
    this.notes,
    this.actualWeight,
    this.estimatedTime,
    this.actualCompletionTime,
    required this.itemTypeResponse,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      id: json['id'] as String,
      itemTypeId: json['itemTypeId'] as String?,
      quantity: json['quantity'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      actualWeight: (json['actualWeight'] as num?)?.toDouble(),
      estimatedTime: json['estimatedTime'] as int?,
      actualCompletionTime: json['actualCompletionTime'] as int?,
      itemTypeResponse: ItemTypeInOrderDetailResponse.fromJson(
        json['itemTypeResponse'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemTypeId': itemTypeId,
      'quantity': quantity,
      'weight': weight,
      'unitPrice': unitPrice,
      'subtotal': subtotal,
      'notes': notes,
      'actualWeight': actualWeight,
      'estimatedTime': estimatedTime,
      'actualCompletionTime': actualCompletionTime,
      'itemTypeResponse': itemTypeResponse.toJson(),
    };
  }
}

class ItemTypeInOrderDetailResponse {
  final String id;
  final String? itemCode;
  final String? name;
  final String? description;
  final double? defaultPrice;
  final double? pricePerItem;
  final double? pricePerKg;
  final String? imageUrl;

  ItemTypeInOrderDetailResponse({
    required this.id,
    this.itemCode,
    this.name,
    this.description,
    this.defaultPrice,
    this.pricePerItem,
    this.pricePerKg,
    this.imageUrl,
  });

  factory ItemTypeInOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return ItemTypeInOrderDetailResponse(
      id: json['id'] as String,
      itemCode: json['itemCode'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      defaultPrice: (json['defaultPrice'] as num?)?.toDouble(),
      pricePerItem: (json['pricePerItem'] as num?)?.toDouble(),
      pricePerKg: (json['pricePerKg'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemCode': itemCode,
      'name': name,
      'description': description,
      'defaultPrice': defaultPrice,
      'pricePerItem': pricePerItem,
      'pricePerKg': pricePerKg,
      'imageUrl': imageUrl,
    };
  }
}
