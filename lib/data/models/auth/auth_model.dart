import 'dart:convert';

class AuthModel {
  String? accessToken;
  String? refreshToken;
  String? userId;
  String? fullName;
  String? status;
  String? role;

  AuthModel({
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.fullName,
    this.status,
    this.role,
  });

  /// Chuyển đối tượng thành JSON (dùng để lưu)
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
      'fullName': fullName,
      'status': status,
      'role': role,
    };
  }

  /// Chuyển JSON string thành đối tượng (dùng khi lấy dữ liệu)
  factory AuthModel.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return AuthModel(
      accessToken: jsonMap['accessToken'],
      refreshToken: jsonMap['refreshToken'],
      userId: jsonMap['userId'],
      fullName: jsonMap['fullName'],
      status: jsonMap['status'],
      role: jsonMap['role'],
    );
  }
}
