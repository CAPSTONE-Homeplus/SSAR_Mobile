import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/failure.dart';

import '../../../core/exception/exception_handler.dart';
import '../../entities/user/user.dart';
import '../../repositories/user_repository.dart';

class GetUsersBySharedWalletUseCase {
  final UserRepository _userRepository;

  GetUsersBySharedWalletUseCase(this._userRepository);

  Future<Either<Failure, BaseResponse<User>>> execute(
    String walletId,
    int? page,
    int? size,
  ) async {
    try {
      final response = await _userRepository.getUsersBySharedWallet(
        walletId,
        page,
        size,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Đã có lỗi xảy ra!'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}