class Staff {
  String? id;
  String? fullName;
  String? phoneNumber;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? address;
  String? hireDate;
  String? jobPosition;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? accountId;
  String? groupId;
  String? code;

  Staff(
      {this.id,
        this.fullName,
        this.phoneNumber,
        this.email,
        this.gender,
        this.dateOfBirth,
        this.address,
        this.hireDate,
        this.jobPosition,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.accountId,
        this.groupId,
        this.code});

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    address = json['address'];
    hireDate = json['hireDate'];
    jobPosition = json['jobPosition'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accountId = json['accountId'];
    groupId = json['groupId'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['address'] = this.address;
    data['hireDate'] = this.hireDate;
    data['jobPosition'] = this.jobPosition;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['accountId'] = this.accountId;
    data['groupId'] = this.groupId;
    data['code'] = this.code;
    return data;
  }
}