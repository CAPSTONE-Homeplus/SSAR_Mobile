import 'package:home_clean/domain/entities/user/create_user.dart';

import '../entities/user/user.dart';

abstract class UserRepository {
  Future<User> createAccount(CreateUser createUser);
}