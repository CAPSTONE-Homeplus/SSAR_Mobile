import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/shared_wallet_screen/screen/shared_wallet.dart';
import 'package:home_clean/presentation/widgets/show_dialog.dart';

import '../../../../core/constant/constants.dart';
import '../../../../domain/entities/wallet/wallet.dart';
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
      body: BlocListener<SharedWalletBloc, WalletState>(
        listener: (context, walletState) {
          if (walletState is WalletError) {
            showCustomDialog(
              context: context,
              message: walletState.message,
              type: DialogType.error,
              onConfirm: () {
                Navigator.pop(context);
              },
            );
          }
        },
        child: BlocBuilder<WalletBloc, WalletState>(
          buildWhen: (previous, current) => current is WalletLoaded,
          builder: (context, walletState) {
            if (walletState is WalletLoaded) {
              return SharedWallet(
                sharedWallet: walletState.wallets.firstWhere(
                        (e) => e.type == 'Shared',
                    orElse: () => throw Exception('No shared wallet found')
                ),
                personalWallet: walletState.wallets.firstWhere(
                        (e) => e.type == 'Personal',
                    orElse: () => throw Exception('No personal wallet found')
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      )
,
    );
  }
}
