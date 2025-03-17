import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/contribution_statistics/contribution_statistics.dart';
import '../../repositories/wallet_repository.dart';

class GetContributionStatisticUseCase {
  final WalletRepository _walletRepository;

  GetContributionStatisticUseCase(this._walletRepository);

  Future<Either<Failure, ContributionStatistics>> execute(String walletId, int days) async {
    try {
      final result = await _walletRepository.getContributionStatistics(walletId, days);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}