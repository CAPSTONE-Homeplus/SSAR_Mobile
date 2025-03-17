import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/data/models/wallet/wallet_model.dart';
import 'package:home_clean/domain/entities/contribution_statistics/contribution_statistics.dart';

import '../entities/wallet/wallet.dart';

abstract class WalletRepository {
  Future<BaseResponse<Wallet>> getWalletByUser(
      int? page,
      int? size);
  Future<Wallet> createSharedWallet();
  Future<bool> inviteMember(String walletId, String userId);
  Future<Wallet> changeOwner(String walletId, String userId);
  Future<bool> deleteUserFromWallet(String walletId, String userId);
  Future<ContributionStatistics> getContributionStatistics(String walletId, int days);
}