import 'package:home_clean/data/models/extra_service/extra_service_model.dart';
import 'package:home_clean/domain/entities/extra_service/extra_service.dart';

class ExtraServiceMapper {
  static ExtraService toEntity(ExtraServiceModel model) {
    return ExtraService(
      id: model.id,
      name: model.name,
      price: model.price,
      status: model.status,
      extraTime: model.extraTime,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      code: model.code,
      serviceId: model.serviceId,
    );
  }

  static ExtraServiceModel toModel(ExtraService entity) {
    return ExtraServiceModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      status: entity.status,
      extraTime: entity.extraTime,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      code: entity.code,
      serviceId: entity.serviceId,
    );
  }

  static List<ExtraService> toListEntity(List<ExtraServiceModel> data) {
    return data.map((item) => toEntity(item)).toList();
  }


  static List<ExtraServiceModel> toListModel(List<ExtraService> data) {
    return data.map((item) => toModel(item)).toList();
  }


}
