import 'package:home_clean/data/models/authen/login_model.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';

import '../../entities/user/create_user.dart';
import '../../entities/user/user.dart';

class UserRegisterUseCase {
  final AuthRepository _userRepository;

  UserRegisterUseCase(this._userRepository);

  Future<User> call(CreateUser createUser) async {
    return await _userRepository.createAccount(createUser);
  }
}