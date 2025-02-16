part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String fullName;
  final String username;
  final String password;
  final String roomCode;

  const RegisterSubmitted({
    required this.fullName,
    required this.username,
    required this.password,
    required this.roomCode,
  });

  @override
  List<Object> get props => [fullName, username, password, roomCode];
}