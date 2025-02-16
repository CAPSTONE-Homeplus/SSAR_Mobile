import '../../../data/repositories/auth/authentication_repository.dart';

class GetUserFromLocalUseCase {
  final AuthenticationRepository _authenticationRepository;
  GetUserFromLocalUseCase(this._authenticationRepository);

  Future<String?> call() async {
    return await _authenticationRepository.getUserName();
  }
}