import 'package:home_clean/data/models/refresh_token/refresh_token_model.dart';

import '../../domain/entities/refresh_token/refresh_token_model.dart';

class RefreshTokenMapper {
  static RefreshToken toEntity (Map<String, dynamic> data) {
    return RefreshToken(
      userId: data['userId'],
      refreshToken: data['refreshToken'],
    );
  }

  static RefreshTokenModel toModel (RefreshToken entity) {
    return RefreshTokenModel(
      userId: entity.userId,
      refreshToken: entity.refreshToken,
    );
  }

}