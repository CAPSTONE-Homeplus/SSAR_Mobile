import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/constants.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/personal_wallet_screen/screen/personal_wallet.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/personal_wallet_screen/screen/personal_wallet_error.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/personal_wallet_screen/screen/personal_wallet_loading.dart';

import '../../../../domain/entities/wallet/wallet.dart';
import '../../../blocs/wallet/wallet_bloc.dart';
import '../../../blocs/wallet/wallet_event.dart';
import '../../../blocs/wallet/wallet_state.dart';


class PersonalWalletScreen extends StatefulWidget {
  const PersonalWalletScreen({Key? key}) : super(key: key);

  @override
  State<PersonalWalletScreen> createState() => _PersonalWalletScreenState();
}

class _PersonalWalletScreenState extends State<PersonalWalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PersonalWalletBloc>().add(GetPersonalWallet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PersonalWalletBloc, WalletState>(
        builder: (context, walletState) {
          if (walletState is WalletLoading) {
            return PersonalWalletLoading();
          }
          if (walletState is PersonalWalletLoaded) {
            return PersonalWallet(
              personalWallet: walletState.wallets.isNotEmpty
                  ? walletState.wallets.first
                  : Wallet(id: '', type: personalWalletString, balance: 0),
            );
          }
          return PersonalWalletError();
          },
      ),
    );
  }
}

