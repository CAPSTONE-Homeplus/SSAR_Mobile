import '../../../domain/entities/additional_service/additional_service_model.dart';

class AdditionalServiceMapper {
  static AdditionalService fromJson(Map<String, dynamic> json) {
    return AdditionalService(
      id: json['id'],
      serviceCode: json['serviceCode'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      priceType: json['priceType'],
      appliesTo: json['appliesTo'],
      processingTimeAdjustment: json['processingTimeAdjustment'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}