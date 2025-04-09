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

class CheckUserInfoSuccess extends UserState {
  final bool isClear;

  CheckUserInfoSuccess(this.isClear);

  @override
  List<Object?> get props => [isClear];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserErrorByPhone extends UserState {
  final String message;

  UserErrorByPhone(this.message);

  @override
  List<Object?> get props => [message];
}


// Get User Wallet State
class UserWalletLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserWalletLoaded extends UserState {
  final BaseResponse<User> users;

  UserWalletLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserWalletError extends UserState {
  final String message;

  UserWalletError(this.message);

  @override
  List<Object?> get props => [message];
}

