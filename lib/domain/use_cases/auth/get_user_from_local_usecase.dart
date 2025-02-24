
import 'package:dartz/dartz.dart';
import 'package:home_clean/core/exception/failure.dart';

import '../../entities/user/user.dart';
import '../../repositories/authentication_repository.dart';

class GetUserFromLocalUseCase {
  final AuthRepository _authenticationRepository;
  GetUserFromLocalUseCase(this._authenticationRepository);

  Future<Either<Failure, User>> call() async {
    try {
      final user = await _authenticationRepository.getUserFromLocal();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Error when getting user from local'));
    }
  }
}