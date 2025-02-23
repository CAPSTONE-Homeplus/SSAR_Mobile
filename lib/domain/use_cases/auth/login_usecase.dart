import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../data/models/auth/login_model.dart';
import '../../repositories/authentication_repository.dart';

class LoginUseCase {
  final AuthRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  Future<Either<String, bool>> call(LoginModel loginModel) async {
    try {
      final result = await _authenticationRepository.login(loginModel);
      return Right(result);
    } on ApiException catch (e) {
      print('API Exception: ${e.description}');
      return Left(e.description ?? 'Đã có lỗi xảy ra!');
    }
  }
}