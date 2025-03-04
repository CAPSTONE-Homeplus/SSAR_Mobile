import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/wallet/wallet.dart';
import '../../repositories/wallet_repository.dart';

class ChangeOwnerUseCase {
  final WalletRepository _walletRepository;

  ChangeOwnerUseCase(this._walletRepository);

  Future<Either<Failure, Wallet>> execute(String walletId, String userId) async {
    try {
      final result = await _walletRepository.changeOwner(walletId, userId);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}