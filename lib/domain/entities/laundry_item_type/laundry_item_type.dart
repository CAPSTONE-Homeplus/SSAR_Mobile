import 'package:equatable/equatable.dart';

class LaundryItemType extends Equatable{
  String? id;
  String? itemCode;
  String? name;
  String? description;
  String? category;
  double? defaultPrice;
  double? pricePerItem;
  double? pricePerKg;
  int? estimatedProcessTime;
  String? imageUrl;
  String? status;
  String? createdAt;
  String? updatedAt;
  double? minWeight;
  double? maxWeight;
  int? standardProcessingTime;
  String? serviceTypeId;
  String? serviceType;

  LaundryItemType({
    this.id,
    this.itemCode,
    this.name,
    this.description,
    this.category,
    this.defaultPrice,
    this.pricePerItem,
    this.pricePerKg,
    this.estimatedProcessTime,
    this.imageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.minWeight,
    this.maxWeight,
    this.standardProcessingTime,
    this.serviceTypeId,
    this.serviceType,
  });


  @override
  List<Object?> get props => [
    id,
    itemCode,
    name,
    description,
    category,
    defaultPrice,
    pricePerItem,
    pricePerKg,
    estimatedProcessTime,
    imageUrl,
    status,
    createdAt,
    updatedAt,
    minWeight,
    maxWeight,
    standardProcessingTime,
    serviceTypeId,
    serviceType,
  ];
}