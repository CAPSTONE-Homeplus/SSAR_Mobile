import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/screens/manage_wallet/manage_wallet_screen/wallet_screen.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/wallet/wallet_bloc.dart';
import '../../../blocs/wallet/wallet_event.dart';
import '../../../blocs/wallet/wallet_state.dart';


class ManageWalletScreen extends StatefulWidget {
  const ManageWalletScreen({Key? key}) : super(key: key);

  @override
  State<ManageWalletScreen> createState() => _ManageWalletScreenState();
}

class _ManageWalletScreenState extends State<ManageWalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetWallet());
    context.read<AuthBloc>().add(GetUserFromLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<WalletBloc, WalletState>(
            listener: (context, state) {
              if (state is WalletError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthenticationFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, walletState) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (walletState is WalletLoading || authState is AuthenticationLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (walletState is WalletLoaded && authState is AuthenticationFromLocal) {
                  return WalletScreen(walletUser: walletState.wallets, user: authState.user);
                }

                return const Center(child: Text('Không thể tải dữ liệu.'));
              },
            );
          },
        ),
      ),
    );
  }
}
