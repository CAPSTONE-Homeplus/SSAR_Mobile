import '../../data/models/auth/login_model.dart';
import '../entities/auth/auth.dart';
import '../entities/user/create_user.dart';
import '../entities/user/user.dart';

abstract class AuthRepository {
  Future<bool> login(LoginModel loginModel);
  Future<User> createAccount(CreateUser createUser);
  Future<Auth> refreshToken();
  Future<User> getUserFromLocal();
}
