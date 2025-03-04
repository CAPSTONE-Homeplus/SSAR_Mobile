import 'package:dartz/dartz.dart';
import 'package:home_clean/core/exception/failure.dart';

import '../../../core/exception/exception_handler.dart';
import '../../repositories/wallet_repository.dart';

class InviteMemberWalletUseCase {
  final WalletRepository _walletRepository;

  InviteMemberWalletUseCase(this._walletRepository);

  Future<Either<Failure, bool>> execute(String walletId, String userId) async {
    try {
      final result = await _walletRepository.inviteMember(walletId, userId); // Thêm await
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }

}