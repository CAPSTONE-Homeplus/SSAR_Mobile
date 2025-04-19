import 'package:equatable/equatable.dart';
import '../../../core/constant/constants.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class SaveTransactionEvent extends TransactionEvent {
  final CreateTransaction transaction;

  const SaveTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class GetTransactionByUserEvent extends TransactionEvent {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  const GetTransactionByUserEvent({this.search, this.orderBy, this.page, this.size});

  @override
  List<Object> get props => [search ?? '', orderBy ?? '',  page ?? Constant.defaultPage, size ?? Constant.defaultSize];
}

class GetTransactionByWalletEvent extends TransactionEvent {
  final String? walletId;
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  const GetTransactionByWalletEvent({this.walletId ,this.search, this.orderBy, this.page, this.size});

  @override
  List<Object> get props => [walletId ?? '', search ?? '', orderBy ?? '', page ?? Constant.defaultPage, size ?? Constant.defaultSize];
}


class SaveTopUpTransactionEvent extends TransactionEvent {
  final CreateTransaction transaction;

  const SaveTopUpTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class SaveLaundryTransactionEvent extends TransactionEvent {
  final CreateTransaction transaction;

  const SaveLaundryTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class SaveCleaningTransactionEvent extends TransactionEvent {
  final CreateTransaction transaction;

  const SaveCleaningTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}


