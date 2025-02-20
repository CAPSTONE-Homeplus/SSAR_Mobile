import 'package:home_clean/data/models/authen/authen_model.dart';

class Authen extends AuthenModel {
  Authen({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String fullName,
    required String status,
    required String role,
  }) : super(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: userId,
          fullName: fullName,
          status: status,
          role: role,
        );
}