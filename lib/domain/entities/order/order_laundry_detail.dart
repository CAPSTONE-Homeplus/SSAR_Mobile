class OrderLaundryDetail {
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
  final List<OrderLaundryItemDetail> orderDetailsByItem;

  OrderLaundryDetail({
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
}

class OrderLaundryItemDetail {
  final String id;
  final String itemTypeId;
  final int quantity;
  final double weight;
  final double unitPrice;
  final double subtotal;
  final String? notes;
  final OrderLaundryItemType itemType;

  OrderLaundryItemDetail({
    required this.id,
    required this.itemTypeId,
    required this.quantity,
    required this.weight,
    required this.unitPrice,
    required this.subtotal,
    this.notes,
    required this.itemType,
  });
}

class OrderLaundryItemType {
  final String id;
  final String itemCode;
  final String name;
  final String description;
  final double defaultPrice;
  final double pricePerItem;
  final double pricePerKg;
  final String? imageUrl;

  OrderLaundryItemType({
    required this.id,
    required this.itemCode,
    required this.name,
    required this.description,
    required this.defaultPrice,
    required this.pricePerItem,
    required this.pricePerKg,
    this.imageUrl,
  });
}
