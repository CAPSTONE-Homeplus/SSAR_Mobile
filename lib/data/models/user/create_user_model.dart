class CreateUserModel {
  String? fullName;
  String? username;
  String? password;
  String? buildingCode;
  String? houseCode;
  String? phoneNumber;
  String? email;

  CreateUserModel({
    this.fullName,
    this.username,
    this.password,
    this.buildingCode,
    this.houseCode,
    this.phoneNumber,
    this.email,
  });

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    username = json['username'];
    password = json['password'];
    buildingCode = json['buildingCode'];
    houseCode = json['houseCode'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['username'] = username;
    data['password'] = password;
    data['buildingCode'] = buildingCode;
    data['houseCode'] = houseCode;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    return data;
  }
}
