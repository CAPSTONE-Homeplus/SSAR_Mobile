import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/shared_wallet_screen/screen/widget/transaction_screen.dart';

import '../../../../../../../domain/entities/wallet/wallet.dart';
import '../../../../blocs/transaction/transaction_event.dart';
import '../../../../blocs/transaction/transation_bloc.dart';
import '../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../blocs/wallet/wallet_event.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'widget/balance_card.dart';

class SharedWallet extends StatefulWidget {
  final Wallet sharedWallet;
  final Wallet personalWallet;

   const SharedWallet({super.key, required this.sharedWallet, required this.personalWallet});

  @override
  _SharedWalletState createState() => _SharedWalletState();
}

class _SharedWalletState extends State<SharedWallet> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _resetSharedWalletData() async {
    context.read<WalletBloc>().add(GetWallet());
    context.read<TransactionBloc>().add(GetTransactionByWalletEvent(walletId: widget.sharedWallet.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Ví chung',
        onBackPressed: () {
          AppRouter.navigateToHome();
        },
      ),
      body: _buildSharedWalletView(),
    );
  }

  Widget _buildSharedWalletView() {
    return RefreshIndicator(
      onRefresh: _resetSharedWalletData,
        child: Column(
          children: [
            BalanceCard(sharedWallet: widget.sharedWallet, personalWallet: widget.personalWallet),
            Expanded(
              child: TransactionScreen(
                wallet: widget.sharedWallet,
                amount: '${widget.sharedWallet.balance}đ',
                isContribution: widget.sharedWallet.balance! > 0,
                time: 'Cập nhật gần đây',
              ),
            ),
          ],
        )
    );
  }
}
