import '../../../data/models/wallet/wallet_model.dart';

class Wallet extends WalletModel {
  Wallet({
    String? id,
    String? name,
    int? balance,
    String? currency,
    String? type,
    String? extraField,
    String? updatedAt,
    String? createdAt,
    String? status,
    String? ownerId,
  }) : super(
    id: id,
    name: name,
    balance: balance,
    currency: currency,
    type: type,
    extraField: extraField,
    updatedAt: updatedAt,
    createdAt: createdAt,
    status: status,
    ownerId: ownerId,
  );
}
