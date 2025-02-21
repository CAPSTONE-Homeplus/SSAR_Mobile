import 'package:home_clean/domain/entities/auth/auth.dart';

import '../../models/auth/auth_model.dart';

class AuthMapper {
  static Auth toEntity (AuthModel model) {
    return Auth(
      accessToken: model.accessToken ?? '',
      refreshToken: model.refreshToken ?? '',
      userId: model.userId ?? '',
      fullName: model.fullName ?? '',
      status: model.status  ?? '',
      role: model.role  ?? '',
    );
  }

  static AuthModel toModel(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      fullName: json['fullName'],
      status: json['status'],
      role: json['role'],
    );
  }
}