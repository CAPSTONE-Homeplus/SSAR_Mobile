import '../../../domain/entities/wallet/wallet.dart';

abstract class WalletState {
}

class WalletInitial extends WalletState {
}

class WalletLoading extends WalletState {
}

class WalletLoaded extends WalletState {
  final List<Wallet> wallets;

  WalletLoaded({required this.wallets});
}

class WalletError extends WalletState {
  final String message;

  WalletError({required this.message});
}




