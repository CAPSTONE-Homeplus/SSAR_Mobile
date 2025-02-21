import '../../repositories/authentication_repository.dart';

class ClearUserFromLocalUseCase {
  final AuthRepository _authenticationRepository;

  ClearUserFromLocalUseCase(this._authenticationRepository);

  Future<void> call() async {
    return await _authenticationRepository.clearUserFromLocal();
  }
}