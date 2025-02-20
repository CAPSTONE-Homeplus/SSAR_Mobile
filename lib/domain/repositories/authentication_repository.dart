import '../entities/auth/authen.dart';
import '../../data/datasource/auth_local_datasource.dart';
import '../../data/models/authen/authen_model.dart';
import '../../data/models/authen/login_model.dart';
import '../entities/user/create_user.dart';
import '../entities/user/user.dart';

abstract class AuthRepository {
  Future<bool> login(LoginModel loginModel);
  Future<User> createAccount(CreateUser createUser);
  Future<void> saveUserFromLocal(User user);
  Future<User> getUserFromLocal();
  Future<void> clearUserFromLocal();
}
