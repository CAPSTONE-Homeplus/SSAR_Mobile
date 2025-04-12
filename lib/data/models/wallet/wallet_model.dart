class WalletModel {
  final String? id;
  final String? name;
  final double? balance; // <-- Đảm bảo kiểu double
  final String? currency;
  final String? type;
  final String? extraField;
  final String? updatedAt;
  final String? createdAt;
  final String? status;
  final String? ownerId;

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

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      name: json['name'],
      balance: (json['balance'] as num?)?.toDouble(), // 👈 Đây là điểm mấu chốt
      currency: json['currency'],
      type: json['type'],
      extraField: json['extraField'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      status: json['status'],
      ownerId: json['ownerId'],
    );
  }

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
}
