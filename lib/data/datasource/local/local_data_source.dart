import 'package:flutter/cupertino.dart';
import 'package:home_clean/data/datasource/local/service_local_data_source.dart';
import 'package:home_clean/data/datasource/local/transaction_local_data_source.dart';
import 'package:home_clean/data/datasource/local/user_local_datasource.dart';
import 'package:home_clean/data/datasource/local/wallet_local_data_source.dart';

import 'auth_local_datasource.dart';
import 'extra_service_local_data_source.dart';
import 'option_local_data_source.dart';

class LocalDataSource {
  final AuthLocalDataSource authLocalDataSource;
  // final ExtraServiceLocalDataSource extraServiceLocalDataSource;
  // final OptionLocalDataSource optionLocalDataSource;
  // final TransactionLocalDataSource transactionLocalDataSource;
  final UserLocalDatasource userLocalDatasource;
  // final WalletLocalDataSource walletLocalDataSource;

  LocalDataSource({
    required this.authLocalDataSource,
    // required this.extraServiceLocalDataSource,
    // required this.optionLocalDataSource,
    // required this.transactionLocalDataSource,
    required this.userLocalDatasource,
    // required this.walletLocalDataSource,
  });


  Future<void> clearAllData() async {
    Map<String, dynamic>? authData = await authLocalDataSource.getAuth();
    if (authData == null) return;
    await authLocalDataSource.clearAuth();
    // await extraServiceLocalDataSource.clearSelectedExtraServiceIds();
    // await optionLocalDataSource.clearSelectedOptionIds();
    await userLocalDatasource.clearUser();
    // await transactionLocalDataSource.clearTransactions(user!);
    debugPrint('Cleared all data');
    // await walletLocalDataSource.clearWallets(user);
  }
}

