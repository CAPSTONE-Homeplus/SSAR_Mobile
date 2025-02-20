class CreateUserModel {
  String? fullName;
  String? username;
  String? password;
  String? roomCode;

  CreateUserModel({
    this.fullName,
    this.username,
    this.password,
    this.roomCode,
  });

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    username = json['username'];
    password = json['password'];
    roomCode = json['roomCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['username'] = username;
    data['password'] = password;
    data['roomCode'] = roomCode;
    return data;
  }
}
