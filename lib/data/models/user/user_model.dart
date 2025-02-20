class UserModel {
  String? id;
  String? fullName;
  String? status;
  String? roomId;
  String? extraField;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? role;


  UserModel({
    this.id,
    this.fullName,
    this.status,
    this.roomId,
    this.extraField,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      status: json['status'],
      roomId: json['roomId'],
      extraField: json['extraField'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      username: json['username'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['status'] = status;
    data['roomId'] = roomId;
    data['extraField'] = extraField;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['username'] = username;
    data['role'] = role;
    return data;
  }
}