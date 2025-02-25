import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../../data/models/auth/login_model.dart';
import '../../repositories/authentication_repository.dart';

class LoginUseCase {
  final AuthRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  Future<Either<Failure, bool>> call(LoginModel loginModel) async {
    try {
      final result = await _authenticationRepository.login(loginModel);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}
