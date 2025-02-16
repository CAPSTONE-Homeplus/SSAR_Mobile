import '../../../data/repositories/auth/authentication_repository.dart';

class ClearUserFromLocalUseCase {
  final AuthenticationRepository _authenticationRepository;

  ClearUserFromLocalUseCase(this._authenticationRepository);

  Future<void> call() async {
    return await _authenticationRepository.clearUser();
  }
}