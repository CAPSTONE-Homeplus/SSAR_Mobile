import '../../../core/base_model.dart';
import '../../entities/wallet/wallet.dart';
import '../../repositories/wallet_repository.dart';

class GetWalletByUserUseCase {
  final WalletRepository _walletRepository;

  GetWalletByUserUseCase(this._walletRepository);

  Future<BaseResponse<Wallet>> execute(int? page, int? size) {
    return _walletRepository.getWalletByUser(page, size);
  }
}