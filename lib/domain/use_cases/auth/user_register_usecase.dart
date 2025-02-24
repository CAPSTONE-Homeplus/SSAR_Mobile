import 'package:dartz/dartz.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';

import '../../../core/exception/exception_handler.dart';
import '../../entities/user/create_user.dart';
import '../../entities/user/user.dart';

class UserRegisterUseCase {
  final AuthRepository _userRepository;

  UserRegisterUseCase(this._userRepository);

  Future<Either<String, User>> call(CreateUser createUser) async {
    try {
      final user = await _userRepository.createAccount(createUser);
      return Right(user);
    } on ApiException catch (e) {
      print('API Exception: ${e.description}');
      return Left(e.description ?? 'Đã có lỗi xảy ra!');
    }
  }
}
