class InviteWalletData {
  final String walletId;
  final String ownerId;
  final String memberId;

  InviteWalletData({
    required this.walletId,
    required this.ownerId,
    required this.memberId,
  });

  factory InviteWalletData.fromJson(Map<String, dynamic> json) {
    return InviteWalletData(
      walletId: json['walletId'],
      ownerId: json['ownerId'],
      memberId: json['memberId'],
    );
  }
}