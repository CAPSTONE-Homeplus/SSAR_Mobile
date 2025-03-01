import 'package:home_clean/domain/entities/user/create_user.dart';

import '../../models/user/create_user_model.dart';

class CreateUserMapper {
  static CreateUser toEntity(CreateUserModel model) {
    return CreateUser(
      username: model.username ?? '',
      password: model.password ?? '',
      fullName: model.fullName ?? '',
      buildingCode: model.buildingCode ?? '',
      houseCode: model.houseCode ?? '',
        phoneNumber: model.phoneNumber ?? '',
        email: model.email ?? '',
    );
  }

  static CreateUserModel toModel(CreateUser entity) {
    return CreateUserModel(
      username: entity.username,
      password: entity.password,
      fullName: entity.fullName,
      buildingCode: entity.buildingCode ?? '',
      houseCode: entity.houseCode ?? '',
      phoneNumber: entity.phoneNumber ?? '',
      email: entity.email ?? '',
    );
  }
}