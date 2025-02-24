class RefreshTokenModel {
  String? userId;
  String? refreshToken;

  RefreshTokenModel({
    this.userId,
    this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['refresh_token'] = refreshToken;
    return data;
  }

  RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    refreshToken = json['refresh_token'];
  }
}