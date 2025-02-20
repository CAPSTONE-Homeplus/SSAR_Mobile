import '../../../data/models/authen/login_model.dart';
import '../../repositories/authentication_repository.dart';

class LoginUseCase {
  final AuthRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  Future<bool> call(LoginModel loginModel) async {
    return await _authenticationRepository.login(loginModel);
  }
}