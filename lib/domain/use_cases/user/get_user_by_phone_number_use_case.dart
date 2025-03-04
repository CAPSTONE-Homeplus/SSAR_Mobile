import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/user/user.dart';
import '../../repositories/user_repository.dart';

class GetUserByPhoneNumberUseCase {
  final UserRepository _userRepository;

  GetUserByPhoneNumberUseCase(this._userRepository);

  Future<Either<Failure, User>> execute(String phone) async {
    try {
      final result = await _userRepository.getUserByPhone(phone);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}