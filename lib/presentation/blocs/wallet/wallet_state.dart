import 'package:equatable/equatable.dart';

import '../../../domain/entities/contribution_statistics/contribution_statistics.dart';
import '../../../domain/entities/wallet/wallet.dart';

abstract class WalletState extends Equatable {
  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {

}

class WalletLoading extends WalletState {
}

class WalletLoaded extends WalletState {
  final List<Wallet> wallets;

  WalletLoaded({required this.wallets});

  @override
  List<Object> get props => [wallets];
}

class PersonalWalletLoaded extends WalletState {
  final List<Wallet> wallets;
  PersonalWalletLoaded(this.wallets);

  @override
  List<Object> get props => [wallets];
}

class SharedWalletLoaded extends WalletState {
  final List<Wallet> wallets;
  SharedWalletLoaded(this.wallets);

  @override
  List<Object> get props => [wallets];
}

class WalletCreatedSuccess extends WalletState {
  final Wallet wallet;

  WalletCreatedSuccess({required this.wallet});

  @override
  List<Object> get props => [wallet];
}

class WalletInviteMemberSuccess extends WalletState {
  final bool result;

  WalletInviteMemberSuccess({required this.result});

  @override
  List<Object> get props => [result];
}


class WalletError extends WalletState {
  final String message;

  WalletError({required this.message});

  @override
  List<Object> get props => [message];
}

class WalletChangeOwnerSuccess extends WalletState {
  final Wallet wallet;

  WalletChangeOwnerSuccess({required this.wallet});

  @override
  List<Object> get props => [wallet];
}

class WalletDeleteSuccess extends WalletState {
  final bool result;

  WalletDeleteSuccess({required this.result});

  @override
  List<Object> get props => [result];
}

class WalletContributionStatisticsLoaded extends WalletState {
  final ContributionStatistics contributionStatistics;

  WalletContributionStatisticsLoaded({required this.contributionStatistics});

  @override
  List<Object> get props => [contributionStatistics];
}


