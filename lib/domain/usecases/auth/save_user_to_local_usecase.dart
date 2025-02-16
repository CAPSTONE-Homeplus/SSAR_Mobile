import '../../../data/repositories/auth/authentication_repository.dart';

class SaveUserToLocalUseCase {
  final AuthenticationRepository _authenticationRepository;

  SaveUserToLocalUseCase(this._authenticationRepository);

  Future<void> call(String userName) async {
    return await _authenticationRepository.saveUserName(userName);
  }
}