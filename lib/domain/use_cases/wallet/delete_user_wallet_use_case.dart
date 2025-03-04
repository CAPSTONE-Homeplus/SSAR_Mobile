import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../repositories/wallet_repository.dart';

class DeleteUserWalletUseCase {
  final WalletRepository _walletRepository;

  DeleteUserWalletUseCase(this._walletRepository);

  Future<Either<Failure, bool>> execute(String walletId, String userId) async {
    try {
      final result = await _walletRepository.deleteUserFromWallet(walletId, userId);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}