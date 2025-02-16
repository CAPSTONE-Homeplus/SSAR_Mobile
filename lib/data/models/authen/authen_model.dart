class AuthenModel {
  String? accessToken;
  String? refreshToken;
  String? userId;
  String? fullName;
  String? status;
  String? role;

  AuthenModel({
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.fullName,
    this.status,
    this.role,
  });

  factory AuthenModel.fromJson(Map<String, dynamic> json) {
    return AuthenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      fullName: json['fullName'],
      status: json['status'],
      role: json['role'],
    );
  }


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

}
