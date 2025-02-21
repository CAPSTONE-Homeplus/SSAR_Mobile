import '../../../data/models/auth/auth_model.dart';

class Auth extends AuthModel {
  Auth({
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