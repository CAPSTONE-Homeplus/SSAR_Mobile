import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';
part 'register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));

      final registrationData = {
        'fullName': event.fullName,
        'username': event.username,
        'password': event.password,
        'roomCode': event.roomCode,
      };

      // TODO: Send registration data to your API
      print('Registration Data: $registrationData');

      emit(RegisterSuccess());
    } catch (error) {
      emit(RegisterFailure(error.toString()));
    }
  }
}