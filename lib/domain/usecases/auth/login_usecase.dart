import '../../../data/models/authen/login_model.dart';
import '../../../data/repositories/auth/authentication_repository.dart';

class LoginUseCase {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  Future<bool> call(LoginModel loginModel) async {
    return await _authenticationRepository.login(loginModel);
  }
}