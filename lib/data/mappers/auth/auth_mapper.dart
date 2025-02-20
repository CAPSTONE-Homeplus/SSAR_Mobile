import 'package:home_clean/data/models/authen/authen_model.dart';
import 'package:home_clean/domain/entities/auth/authen.dart';

class AuthMapper {
  static Authen toEntity (AuthenModel model) {
    return Authen(
      accessToken: model.accessToken ?? '',
      refreshToken: model.refreshToken ?? '',
      userId: model.userId ?? '',
      fullName: model.fullName ?? '',
      status: model.status  ?? '',
      role: model.role  ?? '',
    );
  }

  static AuthenModel toModel (Authen entity) {
    return AuthenModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      userId: entity.userId,
      fullName: entity.fullName,
      status: entity.status,
      role: entity.role,
    );
  }
}