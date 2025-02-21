class CreateUserModel {
  String? fullName;
  String? username;
  String? password;
  String? buildingCode;
  String? houseCode;

  CreateUserModel({
    this.fullName,
    this.username,
    this.password,
    this.buildingCode,
    this.houseCode
  });

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    username = json['username'];
    password = json['password'];
    buildingCode = json['buildingCode'];
    houseCode = json['houseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['username'] = username;
    data['password'] = password;
    data['buildingCode'] = buildingCode;
    data['houseCode'] = houseCode;
    return data;
  }
}
