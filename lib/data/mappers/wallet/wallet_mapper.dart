import 'package:home_clean/data/models/wallet/wallet_model.dart';

import '../../../domain/entities/wallet/wallet.dart';

class WalletMapper {
  static Wallet toEntity (WalletModel walletModel){
    return Wallet(
      id: walletModel.id,
      name: walletModel.name,
      balance: walletModel.balance,
      currency: walletModel.currency,
      type: walletModel.type,
      extraField: walletModel.extraField,
      updatedAt: walletModel.updatedAt,
      createdAt: walletModel.createdAt,
      status: walletModel.status,
      ownerId: walletModel.ownerId,
    );
  }

  static WalletModel toModel (Wallet wallet){
    return WalletModel(
      id: wallet.id,
      name: wallet.name,
      balance: wallet.balance,
      currency: wallet.currency,
      type: wallet.type,
      extraField: wallet.extraField,
      updatedAt: wallet.updatedAt,
      createdAt: wallet.createdAt,
      status: wallet.status,
      ownerId: wallet.ownerId,
    );
  }
}