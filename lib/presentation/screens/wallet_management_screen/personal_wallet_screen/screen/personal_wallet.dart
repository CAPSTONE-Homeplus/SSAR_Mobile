import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/shared_wallet_screen/screen/widget/transaction_screen.dart';

import '../../../../../../../domain/entities/wallet/wallet.dart';
import '../../../../blocs/transaction/transaction_event.dart';
import '../../../../blocs/transaction/transation_bloc.dart';
import '../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../blocs/wallet/wallet_event.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'widget/balance_card.dart';

class PersonalWallet extends StatefulWidget {
  final Wallet personalWallet;

   PersonalWallet({super.key, required this.personalWallet});

  @override
  _PersonalWalletState createState() => _PersonalWalletState();
}

class _PersonalWalletState extends State<PersonalWallet> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _resetSharedWalletData() async {
    context.read<WalletBloc>().add(GetWallet());
    context.read<TransactionBloc>().add(GetTransactionByWalletEvent(walletId: widget.personalWallet.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Ví Cá Nhân',
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _buildSharedWalletView(),
    );
  }

  /// Hiển thị thông tin Ví Chung với lịch sử hoạt động
  Widget _buildSharedWalletView() {

    return RefreshIndicator(
      onRefresh: _resetSharedWalletData,
      child: Column(
        children: [
          BalanceCard(wallet: widget.personalWallet),
          Expanded(
            child: TransactionScreen(
              wallet: widget.personalWallet,
              amount: '${widget.personalWallet.balance}đ',
              isContribution: widget.personalWallet.balance! > 0,
              time: 'Cập nhật gần đây',
            ),
          ),
        ],
      ),
    );
  }

}
