import 'package:equatable/equatable.dart';

abstract class WalletEvent  extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class ChangeOwnerEvent  extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class DissolutionWalletEvent  extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPersonalWallet extends WalletEvent {
  final int? page;
  final int? size;

  GetPersonalWallet({
    this.page,
    this.size,
  });

  @override
  List<Object> get props => [page ?? 0, size ?? 0];
}

class GetSharedWallet extends WalletEvent {
  final int? page;
  final int? size;

  GetSharedWallet({
    this.page,
    this.size,
  });

  @override
  List<Object> get props => [page ?? 0, size ?? 0];
}

class GetWallet extends WalletEvent {
  final int? page;
  final int? size;

  GetWallet({
    this.page,
    this.size,
  });

  @override
  List<Object> get props => [page ?? 0, size ?? 0];
}


class CreateWallet extends WalletEvent {
}

class InviteMember extends WalletEvent {
  final String walletId;
  final String userId;

  InviteMember({
    required this.walletId,
    required this.userId,
  });

  @override
  List<Object> get props => [walletId, userId];
}

class ChangeOwner extends ChangeOwnerEvent{
  final String walletId;
  final String userId;

  ChangeOwner({
    required this.walletId,
    required this.userId,
  });
}

class DeleteWallet extends WalletEvent {
  final String walletId;
  final String userId;

  DeleteWallet({
    required this.walletId,
    required this.userId,
  });

  @override
  List<Object> get props => [walletId, userId];

}

class GetContributionStatistics extends WalletEvent {
  final String walletId;
  final int days;

  GetContributionStatistics({
    required this.walletId,
    required this.days,
  });

  @override
  List<Object> get props => [walletId, days];
}

class DissolutionWallet extends DissolutionWalletEvent{
  final String walletId;

  DissolutionWallet({
    required this.walletId,
  });

  @override
  List<Object> get props => [walletId];
}

