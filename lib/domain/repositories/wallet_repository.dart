import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/data/models/wallet/wallet_model.dart';

import '../entities/wallet/wallet.dart';

abstract class WalletRepository {
  Future<BaseResponse<Wallet>> getWalletByUser(
      int? page,
      int? size);
}