import 'package:home_clean/data/datasource/service_local_data_source.dart';
import 'package:home_clean/data/datasource/transaction_local_data_source.dart';
import 'package:home_clean/data/datasource/user_local_datasource.dart';
import 'package:home_clean/data/datasource/wallet_local_data_source.dart';

import 'auth_local_datasource.dart';
import 'extra_service_local_data_source.dart';
import 'option_local_data_source.dart';

class LocalDataSource {
  final AuthLocalDataSource authLocalDataSource;
  final ExtraServiceLocalDataSource extraServiceLocalDataSource;
  final OptionLocalDataSource optionLocalDataSource;
  final ServiceLocalDataSource serviceLocalDataSource;
  final TransactionLocalDataSource transactionLocalDataSource;
  final UserLocalDatasource userLocalDatasource;
  final WalletLocalDataSource walletLocalDataSource;

  LocalDataSource({
    required this.authLocalDataSource,
    required this.extraServiceLocalDataSource,
    required this.optionLocalDataSource,
    required this.serviceLocalDataSource,
    required this.transactionLocalDataSource,
    required this.userLocalDatasource,
    required this.walletLocalDataSource,
  });


  Future<void> clearAllData() async {
    Map<String, dynamic>? authData = await authLocalDataSource.getAuth();
    if (authData == null) return;
    String? user = authData['userId'];
    await authLocalDataSource.clearAuth();
    await extraServiceLocalDataSource.clearSelectedExtraServiceIds();
    await optionLocalDataSource.clearSelectedOptionIds();
    await serviceLocalDataSource.clearService();
    await userLocalDatasource.clearUser();
    await walletLocalDataSource.clearWallet();
    await transactionLocalDataSource.clearTransactions(user!);

  }
}

