import '../../models/authen/authen_model.dart';
import '../../models/authen/create_authen_model.dart';
import '../../models/authen/login_model.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  Future<AuthenModel?> loginWithGmail(CreateAuthenModel createAuthenModel);

  Future<AuthenModel?> registerAccount(CreateAuthenModel createAuthenModel);

  Future<bool> login(LoginModel loginModel);
}
