class WalletTransferRequest {
  String? sharedWalletId;
  String? personalWalletId;
  int? amount;

  WalletTransferRequest(
      {this.sharedWalletId, this.personalWalletId, this.amount});

  WalletTransferRequest.fromJson(Map<String, dynamic> json) {
    sharedWalletId = json['sharedWalletId'];
    personalWalletId = json['personalWalletId'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sharedWalletId'] = this.sharedWalletId;
    data['personalWalletId'] = this.personalWalletId;
    data['amount'] = this.amount;
    return data;
  }
}
