import '../../datasource/authen_local_datasource.dart';
import '../../models/authen/login_model.dart';

abstract class AuthenticationRepository {
  Future<bool> login(LoginModel loginModel);
  Future<void> saveUserName(String userName);
  Future<String?> getUserName();
  Future<void> clearUser();
}
