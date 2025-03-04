import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/shared_wallet_screen/screen/shared_wallet.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/shared_wallet_screen/screen/shared_wallet_error.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/shared_wallet_screen/screen/shared_wallet_loading.dart';

import '../../../blocs/wallet/wallet_bloc.dart';
import '../../../blocs/wallet/wallet_event.dart';
import '../../../blocs/wallet/wallet_state.dart';


class SharedWalletScreen extends StatefulWidget {
  const SharedWalletScreen({Key? key}) : super(key: key);

  @override
  State<SharedWalletScreen> createState() => _SharedWalletScreenState();
}

class _SharedWalletScreenState extends State<SharedWalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetWallet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, walletState) {
          if (walletState is WalletLoading) {
            return SharedWalletLoading();
          }
          if (walletState is WalletLoaded) {
            return SharedWallet(walletUser: walletState.wallets);
          }
          return SharedWalletError();
          },
      ),
    );
  }
}
