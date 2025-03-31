import '../../../domain/entities/laundry_item_type/laundry_item_type.dart';

class LaundryItemTypeMapper {
  static LaundryItemType fromMap(Map<String, dynamic> map) {
    return LaundryItemType(
      id: map['id'],
      itemCode: map['itemCode'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      defaultPrice: map['defaultPrice'],
      pricePerItem: map['pricePerItem'],
      pricePerKg: map['pricePerKg'],
      estimatedProcessTime: map['estimatedProcessTime'],
      imageUrl: map['imageUrl'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      minWeight: map['minWeight'],
      maxWeight: map['maxWeight'],
      standardProcessingTime: map['standardProcessingTime'],
      serviceTypeId: map['serviceTypeId'],
      serviceTypeName: map['serviceTypeName'],
    );
  }


  static Map<String, dynamic> toMap(LaundryItemType laundryItemType) {
    return <String, dynamic>{
      'id': laundryItemType.id,
      'itemCode': laundryItemType.itemCode,
      'name': laundryItemType.name,
      'description': laundryItemType.description,
      'category': laundryItemType.category,
      'defaultPrice': laundryItemType.defaultPrice,
      'pricePerItem': laundryItemType.pricePerItem,
      'pricePerKg': laundryItemType.pricePerKg,
      'estimatedProcessTime': laundryItemType.estimatedProcessTime,
      'imageUrl': laundryItemType.imageUrl,
      'status': laundryItemType.status,
      'createdAt': laundryItemType.createdAt,
      'updatedAt': laundryItemType.updatedAt,
      'minWeight': laundryItemType.minWeight,
      'maxWeight': laundryItemType.maxWeight,
      'standardProcessingTime': laundryItemType.standardProcessingTime,
      'serviceTypeId': laundryItemType.serviceTypeId,
      'serviceTypeName': laundryItemType.serviceTypeName,
    };
  }
}

