import 'package:home_clean/data/models/option/option_model.dart';
import 'package:home_clean/domain/entities/option/option.dart';

class OptionMapper {
  static Option toEntity(OptionModel model) {
    return Option(
      id: model.id,
      name: model.name,
      price: model.price,
      note: model.note,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isMandatory: model.isMandatory,
      maxQuantity: model.maxQuantity,
      discount: model.discount,
      code: model.code,
      serviceId: model.serviceId,
    );
  }

  static OptionModel toModel(Option entity) {
    return OptionModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      note: entity.note,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isMandatory: entity.isMandatory,
      maxQuantity: entity.maxQuantity,
      discount: entity.discount,
      code: entity.code,
      serviceId: entity.serviceId,
    );
  }
}
