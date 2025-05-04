class UserModel {
  String? id;
  String? fullName;
  String? status;
  String? houseId;
  String? extraField;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? role;
  String? email;
  String? phoneNumber;
  String? citizenCode;
  String? buildingCode;
  String? houseCode;

  UserModel({
    this.id,
    this.fullName,
    this.status,
    this.houseId,
    this.extraField,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.role,
    this.email,
    this.phoneNumber,
    this.citizenCode,
    this.buildingCode,
    this.houseCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      status: json['status'],
      houseId: json['houseId'],
      extraField: json['extraField'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      username: json['username'],
      role: json['role'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      citizenCode: json['citizenCode'],
      buildingCode: json['buildingCode'],
      houseCode: json['houseCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'status': status,
      'houseId': houseId,
      'extraField': extraField,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'username': username,
      'role': role,
      'email': email,
      'phoneNumber': phoneNumber,
      'citizenCode': citizenCode,
      'buildingCode': buildingCode,
      'houseCode': houseCode,
    };
  }
}