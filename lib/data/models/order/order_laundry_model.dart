import 'package:home_clean/domain/entities/order/order_laundry.dart';

class OrderLaundryModel {
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

  OrderLaundryModel({
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
  });

  factory OrderLaundryModel.fromJson(Map<String, dynamic> json) {
    return OrderLaundryModel(
      id: json['id'],
      orderCode: json['orderCode'] ?? '',
      name: json['name'] ?? '',
      userId: json['userId'],
      type: json['type'],
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      status: json['status'],
      orderDate:
          json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  OrderLaundry toEntity() {
    return OrderLaundry(
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
    );
  }
}
