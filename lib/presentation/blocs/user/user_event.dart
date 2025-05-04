import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class GetUsersBySharedWalletEvent extends UserEvent {
  final String walletId;
  final int? page;
  final int? size;

  GetUsersBySharedWalletEvent({
    required this.walletId,
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [walletId, page, size];
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

class GetUserEvent extends UserEvent {
  final String userId;

  GetUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileEvent extends UserEvent {

  final String? fullName;
  final String? username;
  final String? buildingCode;
  final String? houseCode;
  final String? phoneNumber;
  final String? email;

  UpdateProfileEvent({
    this.fullName,
    this.username,
    this.buildingCode,
    this.houseCode,
    this.phoneNumber,
    this.email,
  });

  @override
  List<Object?> get props => [
        fullName,
        username,
        buildingCode,
        houseCode,
        phoneNumber,
        email,
      ];
}