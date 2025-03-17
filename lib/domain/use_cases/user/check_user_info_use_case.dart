import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../repositories/user_repository.dart';

class CheckUserInfoUseCase {
  final UserRepository _userRepository;

  CheckUserInfoUseCase(this._userRepository);

  Future<Either<Failure, bool>> execute(String? phoneNumber, String? email, String? username) async {
    try {
      final result = await _userRepository.checkInfo(phoneNumber, email, username);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}