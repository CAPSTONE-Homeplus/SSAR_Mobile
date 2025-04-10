import 'package:home_clean/domain/entities/order/order_laundry_detail.dart';

class OrderLaundryDetailModel {
  final String id;
  final String orderCode;
  final String name;
  final String userId;
  final String? type;
  final double? totalAmount;
  final String? status;
  final DateTime? orderDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<LaundryOrderItemDetailModel> orderDetailsByItem;

  OrderLaundryDetailModel({
    required this.id,
    required this.orderCode,
    required this.name,
    required this.userId,
    this.type,
    this.totalAmount,
    this.status,
    this.orderDate,
    this.createdAt,
    this.updatedAt,
    required this.orderDetailsByItem,
  });

  factory OrderLaundryDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderLaundryDetailModel(
      id: json['id'],
      orderCode: json['orderCode'],
      name: json['name'],
      userId: json['userId'],
      type: json['type'],
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      status: json['status'],
      orderDate: json['orderDate'] != null
          ? DateTime.tryParse(json['orderDate'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      orderDetailsByItem: (json['orderDetailsByItem'] as List<dynamic>? ?? [])
          .map((e) => LaundryOrderItemDetailModel.fromJson(e))
          .toList(),
    );
  }

  OrderLaundryDetail toEntity() {
    return OrderLaundryDetail(
      id: id,
      orderCode: orderCode,
      name: name,
      userId: userId,
      type: type,
      totalAmount: totalAmount,
      status: status,
      orderDate: orderDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      orderDetailsByItem: orderDetailsByItem.map((e) => e.toEntity()).toList(),
    );
  }
}

class LaundryOrderItemDetailModel {
  final String id;
  final String itemTypeId;
  final int quantity;
  final double weight;
  final double unitPrice;
  final double subtotal;
  final String? notes;
  final LaundryItemTypeResponseModel itemType;

  LaundryOrderItemDetailModel({
    required this.id,
    required this.itemTypeId,
    required this.quantity,
    required this.weight,
    required this.unitPrice,
    required this.subtotal,
    this.notes,
    required this.itemType,
  });

  factory LaundryOrderItemDetailModel.fromJson(Map<String, dynamic> json) {
    return LaundryOrderItemDetailModel(
      id: json['id'],
      itemTypeId: json['itemTypeId'],
      quantity: json['quantity'],
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'],
      itemType: LaundryItemTypeResponseModel.fromJson(json['itemTypeResponse']),
    );
  }

  OrderLaundryItemDetail toEntity() {
    return OrderLaundryItemDetail(
      id: id,
      itemTypeId: itemTypeId,
      quantity: quantity,
      weight: weight,
      unitPrice: unitPrice,
      subtotal: subtotal,
      notes: notes,
      itemType: itemType.toEntity(),
    );
  }
}

class LaundryItemTypeResponseModel {
  final String id;
  final String itemCode;
  final String name;
  final String description;
  final double defaultPrice;
  final double pricePerItem;
  final double pricePerKg;
  final String? imageUrl;

  LaundryItemTypeResponseModel({
    required this.id,
    required this.itemCode,
    required this.name,
    required this.description,
    required this.defaultPrice,
    required this.pricePerItem,
    required this.pricePerKg,
    this.imageUrl,
  });

  factory LaundryItemTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return LaundryItemTypeResponseModel(
      id: json['id'],
      itemCode: json['itemCode'],
      name: json['name'],
      description: json['description'],
      defaultPrice: (json['defaultPrice'] as num?)?.toDouble() ?? 0.0,
      pricePerItem: (json['pricePerItem'] as num?)?.toDouble() ?? 0.0,
      pricePerKg: (json['pricePerKg'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
    );
  }

  OrderLaundryItemType toEntity() {
    return OrderLaundryItemType(
      id: id,
      itemCode: itemCode,
      name: name,
      description: description,
      defaultPrice: defaultPrice,
      pricePerItem: pricePerItem,
      pricePerKg: pricePerKg,
      imageUrl: imageUrl,
    );
  }
}
