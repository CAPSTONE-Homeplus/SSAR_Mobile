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
  final List<Wallet> walletUser;

   PersonalWallet({super.key, required this.walletUser});

  @override
  _PersonalWalletState createState() => _PersonalWalletState();
}

class _PersonalWalletState extends State<PersonalWallet> with SingleTickerProviderStateMixin {
  late Wallet personalWallet;

  @override
  void initState() {
    super.initState();
    personalWallet = widget.walletUser.firstWhere(
          (w) => w.type == 'Personal',
      orElse: () => Wallet(id: '', type: 'Personal', balance: 0),
    );
  }

  Future<void> _resetSharedWalletData() async {
    context.read<WalletBloc>().add(GetWallet());
    context.read<TransactionBloc>().add(GetTransactionByWalletEvent(walletId: personalWallet.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Ví chung',
        onNotificationPressed: () {
        },
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
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            BalanceCard(wallet: personalWallet),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hoạt động gần đây',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TransactionScreen(
                    wallet: personalWallet,
                    amount: '${personalWallet.balance}đ',
                    isContribution: personalWallet.balance! > 0,
                    time: 'Cập nhật gần đây',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
