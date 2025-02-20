class WalletModel {
  String? id;
  String? name;
  int? balance;
  String? currency;
  String? type;
  String? extraField;
  String? updatedAt;
  String? createdAt;
  String? status;
  String? ownerId;

  WalletModel({
    this.id,
    this.name,
    this.balance,
    this.currency,
    this.type,
    this.extraField,
    this.updatedAt,
    this.createdAt,
    this.status,
    this.ownerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
      'type': type,
      'extraField': extraField,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'status': status,
      'ownerId': ownerId,
    };
  }

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      name: json['name'],
      balance: json['balance'],
      currency: json['currency'],
      type: json['type'],
      extraField: json['extraField'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      status: json['status'],
      ownerId: json['ownerId'],
    );
  }
}