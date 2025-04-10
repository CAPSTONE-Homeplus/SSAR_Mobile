class OrderLaundry {
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

  OrderLaundry({
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
}
