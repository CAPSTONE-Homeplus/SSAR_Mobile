import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class GetUsersBySharedWalletEvent extends UserEvent {
  final String walletId;
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetUsersBySharedWalletEvent({
    required this.walletId,
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [walletId, search, orderBy, page, size];
}

class GetUserByPhoneNumberEvent extends UserEvent {
  final String phone;

  GetUserByPhoneNumberEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class CheckUserInfoEvent extends UserEvent {
  final String? phoneNumber;
  final String? email;
  final String? username;

  CheckUserInfoEvent({this.phoneNumber, this.email, this.username});

  @override
  List<Object?> get props => [phoneNumber, email, username];
}