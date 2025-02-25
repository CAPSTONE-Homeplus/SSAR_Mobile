import 'package:dartz/dartz.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/user/create_user.dart';
import '../../entities/user/user.dart';

class UserRegisterUseCase {
  final AuthRepository _authRepository;

  UserRegisterUseCase(this._authRepository);

  Future<Either<Failure, User>> execute(CreateUser createUser) async {
    try {
      final user = await _authRepository.createAccount(createUser);
      return Right(user);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}
