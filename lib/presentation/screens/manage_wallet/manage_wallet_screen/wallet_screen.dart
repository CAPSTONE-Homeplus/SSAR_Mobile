import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/screens/manage_wallet/manage_wallet_screen/widget/share_wallet_transaction_screen.dart';

import '../../../../../domain/entities/user/user.dart';
import '../../../../../domain/entities/wallet/wallet.dart';
import '../../../blocs/transaction/transaction_event.dart';
import '../../../blocs/transaction/transation_bloc.dart';
import '../../../blocs/wallet/wallet_bloc.dart';
import '../../../blocs/wallet/wallet_event.dart';
import '../../../widgets/custom_app_bar.dart';
import 'widget/balance_card.dart';

class WalletScreen extends StatefulWidget {
  final List<Wallet> walletUser;
  final User? user;

   const WalletScreen({super.key, required this.walletUser, required this.user});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Wallet sharedWallet;
  late Wallet personalWallet;

  @override
  void initState() {
    super.initState();
    sharedWallet = widget.walletUser.firstWhere(
          (w) => w.type == 'Shared',
      orElse: () => Wallet(id: '', type: 'Shared', balance: 0),
    );
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _resetSharedWalletData() async {
    context.read<WalletBloc>().add(GetWallet());
    context.read<TransactionBloc>().add(GetTransactionByWalletEvent(walletId: sharedWallet.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Ví chung',
        onNotificationPressed: () {
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
            BalanceCard(wallet: sharedWallet),
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
                  ShareWalletTransactionScreen(
                    wallet: sharedWallet,
                    amount: '${sharedWallet.balance}đ',
                    isContribution: sharedWallet.balance! > 0,
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
