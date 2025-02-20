abstract class WalletEvent {
}

class GetWallet extends WalletEvent {
  final int? page;
  final int? size;

  GetWallet({
    this.page,
    this.size,
  });
}