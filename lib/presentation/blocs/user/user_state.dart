import 'package:equatable/equatable.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../domain/entities/user/user.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoaded extends UserState {
  final BaseResponse<User> users;

  UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserLoadedByPhone extends UserState {
  final User user;

  UserLoadedByPhone(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}

